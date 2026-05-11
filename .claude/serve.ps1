# Tiny static-file server for the AnchorSOL site.
# Usage: powershell -ExecutionPolicy Bypass -File serve.ps1 [-Port 8000] [-Root site]
param(
  [int]$Port = 0,
  [string]$Root = "site"
)

$ErrorActionPreference = "Stop"

# Honour PORT env var if set (used by Claude preview when autoPort: true)
if ($env:PORT) { $Port = [int]$env:PORT }
if ($Port -eq 0) { $Port = 8000 }

# Resolve root to absolute path (relative to repo root, which is the parent of .claude)
$repoRoot = Split-Path -Parent $PSScriptRoot
$absRoot  = Join-Path $repoRoot $Root
if (-not (Test-Path $absRoot)) { Write-Error "Root not found: $absRoot"; exit 1 }

$mime = @{
  ".html"="text/html; charset=utf-8"; ".htm"="text/html; charset=utf-8"
  ".css"="text/css; charset=utf-8"; ".js"="application/javascript; charset=utf-8"
  ".json"="application/json; charset=utf-8"; ".svg"="image/svg+xml"
  ".png"="image/png"; ".jpg"="image/jpeg"; ".jpeg"="image/jpeg"
  ".gif"="image/gif"; ".webp"="image/webp"; ".ico"="image/x-icon"
  ".woff"="font/woff"; ".woff2"="font/woff2"
  ".pdf"="application/pdf"; ".txt"="text/plain; charset=utf-8"
}

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$Port/")
$listener.Prefixes.Add("http://127.0.0.1:$Port/")
$listener.Start()
Write-Host "Serving $absRoot on http://localhost:$Port/"
Write-Host "Press Ctrl+C to stop."

try {
  while ($listener.IsListening) {
    $ctx = $listener.GetContext()
    try {
      $req = $ctx.Request
      $res = $ctx.Response

      $relPath = [System.Net.WebUtility]::UrlDecode($req.Url.AbsolutePath).TrimStart('/')
      if ([string]::IsNullOrEmpty($relPath)) { $relPath = "index.html" }

      $full = Join-Path $absRoot $relPath
      if ((Test-Path $full -PathType Container)) { $full = Join-Path $full "index.html" }

      # If requested path has no extension and no file, try appending .html (clean URL fallback)
      if (-not (Test-Path $full -PathType Leaf) -and ([System.IO.Path]::GetExtension($full) -eq "")) {
        $tryHtml = "$full.html"
        if (Test-Path $tryHtml -PathType Leaf) { $full = $tryHtml }
      }

      if (-not (Test-Path $full -PathType Leaf)) {
        $res.StatusCode = 404
        $body = [Text.Encoding]::UTF8.GetBytes("<h1>404 Not Found</h1><p>$relPath</p>")
        $res.ContentType = "text/html; charset=utf-8"
        $res.ContentLength64 = $body.Length
        $res.OutputStream.Write($body, 0, $body.Length)
        $res.Close()
        Write-Host "404  $relPath"
        continue
      }

      $ext = [System.IO.Path]::GetExtension($full).ToLower()
      $ct = $mime[$ext]
      if (-not $ct) { $ct = "application/octet-stream" }
      $res.ContentType = $ct
      $bytes = [System.IO.File]::ReadAllBytes($full)
      $res.ContentLength64 = $bytes.Length
      $res.AddHeader("Cache-Control", "no-cache")
      $res.OutputStream.Write($bytes, 0, $bytes.Length)
      $res.Close()
      Write-Host "200  $relPath  ($($bytes.Length) bytes)"
    } catch {
      try {
        $ctx.Response.StatusCode = 500
        $err = [Text.Encoding]::UTF8.GetBytes("500: " + $_.Exception.Message)
        $ctx.Response.OutputStream.Write($err, 0, $err.Length)
        $ctx.Response.Close()
      } catch {}
      Write-Host "ERR  $($_.Exception.Message)"
    }
  }
} finally {
  $listener.Stop()
  $listener.Close()
}
