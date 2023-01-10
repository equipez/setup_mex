function success = try_mex_setup(language)
%TRY_MEX_SETUP tries running MEX setup for compiling language.
% At return,
% success = 1 means MEX is well configured,
% success = 0 means MEX is not well configured,
% success = -1 means "mex -setup" runs successfully, but either we cannot try
% it on the example file because such a file is not found, or the MEX file of
% the example file does not work as expected.

success = 1;

% Return if MEX is already well configured. This is important, because MEX will be usable
% permanently once it is set up, and because MEX setup may fail not even if it succeeded before due
% to change of environment variables such as ONEAPI_ROOT.
if mex_well_configured(language)
    return
end

orig_warning_state = warning;
warning('off','all'); % We do not want to see warnings when verifying MEX

ulang = upper(language);

% Try `mex('-setup', ulang)`
mex_setup = -1;
exception = [];
try
    %[~, mex_setup] = evalc('mex(''-setup'', ulang)'); % Use evalc so that no output will be displayed
    mex_setup = mex('-setup', ulang); % mex -setup may be interactive. So it is not good to mute it completely!!!
catch exception
    % Do nothing
end
% If MEX setup fails on macOS or Windows, it is probably because of failing to find a supported
% compiler. On MATLAB 2022a or above, MEX can be set up using the Fortran compiler in Intel OneAPI,
% which is available for free. ONEAPI_ROOT to the default values and
if (ismac || (ispc && ~isunix)) && (~isempty(exception) || mex_setup ~= 0)
    old_oneapi_root = getenv('ONEAPI_ROOT');
    if ismac
        setenv('ONEAPI_ROOT', '/opt/intel/oneapi');
    elseif ispc && ~isunix  % Windows
        setenv('ONEAPI_ROOT', 'C:\Program Files (x86)\Intel\oneAPI');
    end
    try
        %[~, mex_setup] = evalc('mex(''-setup'', ulang)'); % Use evalc so that no output will be displayed
        mex_setup = mex('-setup', ulang); % mex -setup may be interactive. So it is not good to mute it completely!!!
    catch exception
        setenv('ONEAPI_ROOT', old_oneapi_root);
    end
end

    fprintf('\nYour MATLAB failed to run mex(''-setup'', ''%s'').', language);
    fprintf('\nTo see the detailed error message, execute the following command:');
    fprintf('\n\n  mex(''-v'', ''-setup'', ''%s'')\n\n', language)
    success = 0;
    % Try `mex(example_file)`
    success = mex_well_configured(language);

% Restore the behavior of displaying warnings
warning(orig_warning_state);

return


%--------------------------------------------------------------------------------------------------%
function success = mex_well_configured(language)
%MEX_WELL_CONFIGURED verifies whether MEX is well configured for compiling language.
% At return,
% success = 1 means MEX is well configured,
% success = 0 means MEX is not well configured,
% success = -1 means "mex -setup" runs successfully, but either we cannot try
% it on the example file because such a file is not found, or the MEX file of
% the example file does not work as expected.

success = 1;

orig_warning_state = warning;
warning('off','all'); % We do not want to see warnings when verifying MEX

callstack = dbstack;
funname = callstack(1).name; % Name of the current function

% Locate example_file, which is an example provided by MATLAB for trying MEX.
% NOTE: MATLAB MAY CHANGE THE LOCATION OF THIS FILE IN THE FUTURE.
ulang = upper(language);
switch ulang
case 'FORTRAN'
    example_file_name = 'timestwo.F';
case {'C', 'C++', 'CPP'}
    example_file_name = 'timestwo.c';
otherwise
    error(sprintf('%s:UnsupportedLang', funname), '%s: Language ''%s'' is not supported by %s.', funname, language, funname);
end
example_file = fullfile(matlabroot, 'extern', 'examples', 'refbook', example_file_name);

% Check whether example_file exists
if ~exist(example_file, 'file')
    fprintf('\n')
    wid = sprintf('%s:ExampleFileNotExist', funname);
    warning('on', wid);
    warning(wid, 'We cannot find\n%s,\nwhich is a MATLAB built-in example for trying MEX on %s. It will be ignored.\n', example_file, language);
    success = -1;
    return
end

% Try `mex(example_file)`
%!------------------------------------------------------------------------------------------------!%
% In general, we should clear a MEX function before compiling it. Otherwise, it may lead to a
% failure of even crash. See https://github.com/equipez/test_matlab/tree/master/crash
% Without the next line, `mex(example_file)` fails on Windows if we run this script two times.
clear('timestwo');
%!------------------------------------------------------------------------------------------------!%
temp_mexdir = tempdir();  % The directory to output the MEX file of `timestwo`.
mex_status = -1;
exception = [];
try
    [~, mex_status] = evalc('mex(example_file, ''-outdir'', temp_mexdir)'); % Use evalc so that no output will be displayed
catch exception
    % Do nothing
end

trash_files = files_with_wildcard(temp_mexdir, 'timestwo.*');

if ~isempty(exception) || mex_status ~= 0
    cellfun(@(filename) delete(filename), trash_files);  % Clean up the trash before returning
    fprintf('\nThe MEX of your MATLAB failed to compile\n%s,\nwhich is a MATLAB built-in example for trying MEX on %s.\n', example_file, language);
    fprintf('\nTo see the detailed error message, execute the following command:');
    fprintf('\n\n  mex(''-v'', fullfile(matlabroot, ''extern'', ''examples'', ''refbook'', ''%s''));\n\n', example_file_name);
    success = 0;
    return
end

% Check whether the mexified example_file works
addpath(temp_mexdir);  % Make `timestwo` available on path
exception = [];
try
    [~, timestwo_out] = evalc('timestwo(1)'); % Try whether timestwo works correctly
catch exception
    % Do nothing
end

rmpath(temp_mexdir);  % Clean up the path before returning.
cellfun(@(filename) delete(filename), trash_files);  % Clean up the trash before returning

if ~isempty(exception)
    fprintf('\nThe MEX of your MATLAB compiled\n%s,\nbut the resultant MEX file does not work.\n', example_file);
    success = 0;
elseif abs(timestwo_out - 2)/2 >= 10*eps
    fprintf('\n')
    wid = sprintf('%s:ExampleFileWorksIncorrectly', funname);
    warning('on', wid);
    warning(wid, 'The MEX of your MATLAB compiled\n%s,\nbut the resultant MEX file returns %.16f when calculating 2 times 1.', example_file, timestwo_out);
    success = -1;
end

% Restore the behavior of displaying warnings
warning(orig_warning_state);

return
