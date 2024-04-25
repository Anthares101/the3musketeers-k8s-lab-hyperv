If((test-path -PathType container tmp))
{
    Remove-Item -LiteralPath "tmp" -Force -Recurse
}
