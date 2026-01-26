let
  # --- Admin SSH keys ---
  kevin-macbook = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOavirFl6Xk3GR2bFfGzX28RYqfwld5lnBdSjTTCAV/0 kevin@macbook";
  
  # --- Machine SSH keys ---
  watson = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPlaceholder watson";
  
  # --- Groups ---
  admins = [ kevin-macbook ];
  machines = [ watson ];
in
{
  # password hashes
  "kevin-password.age".publicKeys = admins;
}