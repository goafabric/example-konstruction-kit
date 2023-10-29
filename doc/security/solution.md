# implementation
No Code, just configuration
Technology agnostic
Identity Provider agnostic
                
# flow
frontend -> gateway -> identity provider -> keycloak
frontend -> gateway -> identity provider -> facebook
frontend -> gateway -> identity provider -> company specific

auth ok -> backend -> spring boot
auth ok -> backend -> .NET
auth ok -> backend -> helix

entire communication can be encrypted via (m)TLS

# c5 compliance

💪strong passwords (>= 10 chars, upper, lower, digits)
🔑️2 factor authentication, via one time token generator
🔒brute force detection (lockout after 5 failed attempts, intentionally not visible)

