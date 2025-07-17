@echo off
setlocal EnableDelayedExpansion

set "target_dir=%~dp0"
set "output_file=%target_dir%.gitignore"
set "size_limit=104857600"  :: 100 MB

rem Clean the old .gitignore file and add a header
> "%output_file%" echo # Auto-generated entries for files larger than 100 MB
echo Searching for files larger than 100 MB...
echo.

for /r "%target_dir%" %%F in (*) do (
    if %%~zF GEQ %size_limit% (
        
        rem Assign the full path to a variable. Delayed expansion is ON here.
        set "full_path=%%~fF"
        
        rem *** THE DEFINITIVE FIX ***
        rem Use 'call set' to perform a double expansion. This correctly substitutes
        rem the path while preserving special characters like '!'.
        call set "rel_path=%%full_path:!target_dir!=%%"
        
        rem Now that we have the correct relative path, replace the slashes.
        set "rel_path_fwd=!rel_path:\=/!"
        
        rem Use a FOR variable to safely 'echo' the final path.
        rem This is still the safest way to print strings with special characters.
        for %%G in ("!rel_path_fwd!") do (
            >>"%output_file%" echo /%%~G
            echo Added: /%%~G
        )
    )
)

echo.
echo Selesai. File besar telah ditambahkan ke .gitignore
pause
goto :eof