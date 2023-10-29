# C5
- IDM-08: Change of initial Password, valid for 14 days, or Users can create their own (IDM-08)
- IDM-09: Password length of 10, 3 types of chars (upper, lower, numbers, special)
- IDM-09: Multi Factor Authentication with OTP, Eventually Passkeys
- IDM-11: Priviliged Users need length of 14 + 3 types + mfa
- IDM-11: Brute Force Detection, 15 min lock after 5 attempts,
- 
- IDM-11 (possible): Existing Pws valid for 90 days for existing ones, PW History of 12 => both are possible in policies 
- IDM-11 (optional): Only one Login/User allowed, Lock/Logout after 15 Min idle => first via session limit in user flow, 2nd via session idle in realm settings, but only if login gets called

# BSI pw recommendation
# https://www.bsi.bund.de/EN/Themen/Verbraucherinnen-und-Verbraucher/Informationen-und-Empfehlungen/Cyber-Sicherheitsempfehlungen/Accountschutz/Sichere-Passwoerter-erstellen/sichere-passwoerter-erstellen.html

- It is 20 to 25 characters long and uses two types of character (e.g. a sequence of words). This kind of password is long and less complex.
- It is eight to 12 characters long and uses four types of character. This kind of password is short and complex.
- It is eight characters long, uses three types of character and is also protected by multi-factor authentication (e.g. in the form of a fingerprint, verification via app or a PIN). This is the recommended method, generally speaking.
- upper-case and lower-case letters, numbers and special characters
