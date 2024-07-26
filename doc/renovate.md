also basierend auf den PRs die Renovate anlegt vermute ich muss man das renovate.json File in Main committen damit er los legen kann. 
Dafür hat er ja auch einen PR erstellt. Sobald dass dann erfolgt ist würde er versuchen die Dependencies upzudaten - aktuell 10 was erstmal ok klingt.


renovate selber führt keine Tests aus sondern der Ablauf ist der folgende:
• renovate updated eine Dependency und committed den Code auf einen Branch (default
renovate/<dependency_name>_<version>
• je nach Setting macht er dann auch einen PR
• das committen triggert das bauen und der BuildStatus wird zurückgemeldet
• beim nächsten Mal wenn renovate läuft überprüft er den BuildStatus der Branches die er angelegt hat und führt die entsprechende Aktion aus (PR erstellen, automerge, ...)
• wenn man die PRs schließt heißt das für Renovate das er diese Version nicht mehr updaten soll
• wenn man manuell mit den PRs interagiert (z.B. weil man Dinge fixt die er nicht kann) muss man danach selber den
PR mergen selbst wenn eigentlich automerge aktiviert ist