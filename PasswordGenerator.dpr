program PasswordGenerator;

{$APPTYPE CONSOLE}

uses
  SysUtils;

const
  LowercaseChars = 'abcdefghijklmnopqrstuvwxyz';
  UppercaseChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  NumberChars = '0123456789';
  SymbolChars = '!@#$%^&*()_-+=<>?';

function GetRandomChar(const validChars: string): Char;
begin
  Result := validChars[Random(Length(validChars)) + 1];
end;

function GeneratePassword(length: Integer; useLowercase, useUppercase, useNumbers, useSymbols: Boolean): string;
var
  i: Integer;
  charSet: string;
begin
  charSet := '';
  if useLowercase then
    charSet := charSet + LowercaseChars;
  if useUppercase then
    charSet := charSet + UppercaseChars;
  if useNumbers then
    charSet := charSet + NumberChars;
  if useSymbols then
    charSet := charSet + SymbolChars;

  if charSet = '' then
    raise Exception.Create('At least one character type must be selected.');

  Randomize;
  Result := '';
  for i := 1 to length do
    Result := Result + GetRandomChar(charSet);
end;

procedure GenerateAndSavePasswords(length: Integer; useLowercase, useUppercase, useNumbers, useSymbols: Boolean; count: Integer; outputFile: string);
var
  password: string;
  fileStream: TextFile;
  i: Integer;
begin
  AssignFile(fileStream, outputFile);
  Rewrite(fileStream);
  try
    for i := 1 to count do
    begin
      password := GeneratePassword(length, useLowercase, useUppercase, useNumbers, useSymbols);
      WriteLn(fileStream, 'Password ', i, ': ', password);
    end;
    Writeln('Passwords saved to file: ', outputFile);
  finally
    CloseFile(fileStream);
  end;
end;

var
  length, count: Integer;
  useLowercase, useUppercase, useNumbers, useSymbols: Boolean;
  outputFile: string;
  userInput: string;
begin
  try
    Writeln('ZugZang Free Password Generator 2025');
    Writeln('************************************');
    Writeln('https://t.me/ZugZangCraft  |  https://shoppy.gg/@ZugZang');
    Writeln('');

    Writeln('Enter password length:');
    ReadLn(length);

    Writeln('Use lowercase letters? (1 for yes, 0 for no):');
    ReadLn(userInput);
    useLowercase := userInput = '1';

    Writeln('Use uppercase letters? (1 for yes, 0 for no):');
    ReadLn(userInput);
    useUppercase := userInput = '1';

    Writeln('Use numbers? (1 for yes, 0 for no):');
    ReadLn(userInput);
    useNumbers := userInput = '1';

    Writeln('Use symbols? (1 for yes, 0 for no):');
    ReadLn(userInput);
    useSymbols := userInput = '1';

    Writeln('Enter output file name:');
    ReadLn(outputFile);

    Writeln('Enter number of passwords to generate:');
    ReadLn(count);
  except
    on E: Exception do
    begin
      Writeln('Error: ', E.Message);
      Exit;
    end;
  end;

  try
    GenerateAndSavePasswords(length, useLowercase, useUppercase, useNumbers, useSymbols, count, outputFile);
  except
    on E: Exception do
    begin
      Writeln(E.ClassName, ': ', E.Message);
      Halt(1); // Exit
    end;
  end;
end.
