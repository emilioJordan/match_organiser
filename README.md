# Match Organiser
## Modul 223: Multi-User-Applikationen objektorientiert realisieren

**Autor:** Emilio Jordan  
**Klasse:** 23-223 E  
**Datum:** 25.09.2025

Eine Ruby on Rails Multiuser-Applikation zur Organisation von Freizeitspielen und Sportevents.

## Problemstellung

Freizeit-Sportgruppen stehen regelmäßig vor dem Problem, Spiele effizient zu organisieren. Oft ist unklar, wie viele Spieler teilnehmen, da Zu- oder Absagen über verschiedene Kanäle (Chats, Telefon, E-Mail) verstreut sind. Dies führt häufig zu Unsicherheit oder sogar Absagen, weil nicht klar ist, ob genügend Spieler erscheinen.

## Projektlösung

Der Match Organiser bietet eine zentrale, digitale Lösung mit klarer Rollenverteilung und Multiuser-Funktionalität für bessere Planungstransparenz.

## Funktionale Anforderungen (MVP)

1. **Benutzerregistrierung und -login** mit Rollenauswahl
2. **Match-Erstellung** durch Organisatoren (Titel, Datum, Zeit, Ort)
3. **Match-Anzeige** für alle registrierten Benutzer
4. **Teilnahme-Zusagen/-Absagen** durch Spieler
5. **Teilnehmerliste** auf Match-Detailseite
6. **Match-Bearbeitung und -löschung** durch Ersteller

## Nicht-funktionale Anforderungen

1. **Benutzerfreundlichkeit**: Intuitive, responsive Bootstrap-Oberfläche
2. **Multiuser-Fähigkeit**: Gleichzeitige Nutzung durch mehrere Benutzer
3. **Performance**: Optimierte Datenbankabfragen mit Eager Loading
4. **Wartbarkeit**: Saubere MVC-Struktur nach Rails-Konventionen
5. **Sicherheit**: BCrypt-Verschlüsselung und Session-Management

## Technische Details

- **Ruby Version**: 3.4.5
- **Rails Version**: 8.0.3
- **Datenbank**: SQLite3
- **Frontend**: Bootstrap 5.3 mit Font Awesome Icons
- **Authentication**: has_secure_password (BCrypt)

## Datenbankschema (ERM)

### Matches
- **id** (PK)
- **title**: Titel des Matches
- **description**: Beschreibung
- **date**: Datum
- **time**: Uhrzeit
- **location**: Ort
- **created_by_id** (FK → users)
- **created_at**: Erstellungszeitpunkt
- **updated_at**: Letzter Änderungszeitpunkt

### Users
- **id** (PK)
- **name**: Benutzername
- **email**: E-Mail-Adresse
- **password_digest**: Verschlüsseltes Passwort
- **role**: Rolle (organizer/player)
- **created_at**: Erstellungszeitpunkt
- **updated_at**: Letzter Änderungszeitpunkt

### Participations
- **id** (PK)
- **user_id** (FK → users)
- **match_id** (FK → matches)
- **status**: Status der Teilnahme
- **created_at**: Erstellungszeitpunkt
- **updated_at**: Letzter Änderungszeitpunkt

### Beziehungen
- Ein **User** kann mehrere **Matches** erstellen (als Organizer)
- Ein **User** kann an mehreren **Matches** teilnehmen (als Player)
- Ein **Match** hat einen **User** als Ersteller
- Ein **Match** kann mehrere **Users** als Teilnehmer haben
- Die **Participation** verbindet **Users** und **Matches** und speichert den Teilnahmestatus

## Installation und Setup

### Voraussetzungen

- Ruby 3.4.5
- Rails 8.0.3
- SQLite3
- Node.js (für Asset Pipeline)

### Installation

1. Repository klonen:
```bash
git clone <repository-url>
cd match_organiser
```

2. Dependencies installieren:
```bash
bundle install
```

3. Datenbank erstellen und migrieren:
```bash
rails db:create
rails db:migrate
```

4. Seed-Daten laden (optional):
```bash
rails db:seed
```

5. Server starten:
```bash
rails server
```

6. Applikation öffnen: [http://localhost:3000](http://localhost:3000)

## Benutzung

### Test-Benutzer (nach `rails db:seed`)

**Organisatoren:**
- Max Müller: `max@example.com` / `password`
- Sarah Schmidt: `sarah@example.com` / `password`

**Spieler:**
- Tom Weber: `tom@example.com` / `password` 
- Lisa Fischer: `lisa@example.com` / `password`
- Mike Johnson: `mike@example.com` / `password`

### Benutzerrollen

**Organizer:**
- Kann Matches erstellen, bearbeiten und löschen
- Verwaltet eigene Matches
- Kann Teilnehmerlisten einsehen

**Player:**
- Kann Matches einsehen
- Kann Teilnahme zusagen/absagen
- Kann eigene Teilnahme-Status ändern

## Domänenmodell und Architektur

### Entity-Relationship-Model (ERM)

```
┌─────────────────┐     ┌──────────────────┐     ┌─────────────────┐
│      User       │────▷│   Participation  │◁────│      Match      │
├─────────────────┤     ├──────────────────┤     ├─────────────────┤
│ id (PK)         │     │ id (PK)          │     │ id (PK)         │
│ name            │     │ user_id (FK)     │     │ title           │
│ email           │     │ match_id (FK)    │     │ description     │
│ password_digest │     │ status           │     │ date            │
│ role            │     └──────────────────┘     │ time            │
└─────────────────┘                              │ location        │
         │                                       │ created_by (FK) │
         └───────────────────────────────────────┴─────────────────┘
              creates (1:n)
```

### Datenmodell-Definitionen

**User (Benutzer)**
- **Attribute**: `id`, `name`, `email`, `password_digest`, `role`
- **Rollen**: `organizer` (kann Matches erstellen), `player` (kann teilnehmen)
- **Validierungen**: E-Mail eindeutig, Name erforderlich

**Match (Sportspiel)**
- **Attribute**: `id`, `title`, `description`, `date`, `time`, `location`, `created_by_id`
- **Beziehungen**: Gehört zu einem User (Organizer)
- **Validierungen**: Titel, Datum, Zeit und Ort erforderlich

**Participation (Teilnahme)**
- **Attribute**: `id`, `user_id`, `match_id`, `status`
- **Status-Werte**: `confirmed`, `declined`, `pending`
- **Join-Tabelle**: Verbindet User und Match (n:m-Beziehung)

### Objektorientierte Beziehungen

```ruby
# Ein User kann viele Matches erstellen (1:n)
User.has_many :created_matches, class_name: 'Match', foreign_key: 'created_by_id'

# Ein User kann an vielen Matches teilnehmen (n:m über Participation)
User.has_many :participations
User.has_many :matches, through: :participations

# Ein Match gehört zu einem User (Organizer)
Match.belongs_to :created_by, class_name: 'User'

# Ein Match hat viele Teilnehmer (n:m über Participation)  
Match.has_many :participations
Match.has_many :participants, through: :participations, source: :user
```

## Features

### MVP (Minimum Viable Product)

✅ **Benutzerregistrierung und -login**  
✅ **Match-Erstellung** durch Organisatoren  
✅ **Match-Anzeige** für alle Benutzer  
✅ **Teilnahme-Zusagen/-Absagen**  
✅ **Teilnehmerliste** auf Match-Detailseite  
✅ **Match-Bearbeitung** und -löschung durch Ersteller  

### UI/UX Features

- Responsive Design mit Bootstrap
- Intuitive Navigation
- Flash-Messages für Benutzer-Feedback
- Icon-unterstützte Benutzeroberfläche
- Farbkodierte Teilnahme-Status

## Multi-User-Funktionalitäten

### Authentifizierung
```ruby
# Sichere Passwort-Speicherung mit BCrypt
class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true
end

# Session-basierte Anmeldung
def create
  user = User.find_by(email: params[:email])
  if user&.authenticate(params[:password])
    session[:user_id] = user.id
    redirect_to root_path
  end
end
```

### Benutzerrollen und Berechtigungen
- **Organizer**: Kann Matches erstellen, bearbeiten und löschen
- **Player**: Kann Matches ansehen und Teilnahme-Status ändern
- **Rollenbasierte Navigation**: Verschiedene UI-Elemente je nach Rolle

```ruby
# Autorisierung im Controller
before_action :require_organizer, only: [:new, :create, :edit, :update, :destroy]

def require_organizer
  unless current_user.organizer?
    flash[:alert] = "Nur Organisatoren können Matches verwalten"
    redirect_to matches_path
  end
end
```

### Aktivitätsprotokoll und User Feedback
- **Flash Messages**: Erfolgs- und Fehlermeldungen für alle Aktionen
- **Session Management**: Sichere Anmeldung und automatische Weiterleitung
- **Error Handling**: Validierungsfehler werden benutzerfreundlich angezeigt

## Sicherheitsaspekte

- **Passwort-Verschlüsselung**: BCrypt-Hashing für sichere Speicherung
- **Session-Sicherheit**: Rails-integriertes Session-Management
- **CSRF-Schutz**: Automatischer Cross-Site Request Forgery Schutz
- **Input-Validierung**: Serverseitige Validierung aller Benutzereingaben
- **Autorisierung**: Rollenbasierte Zugriffskontrolle auf Controller-Ebene
- **SQL-Injection-Schutz**: ActiveRecord schützt vor SQL-Injection

## Development

### Database

```bash
# Neue Migration erstellen
rails generate migration MigrationName

# Migrations ausführen
rails db:migrate

# Rollback
rails db:rollback

# Datenbank zurücksetzen
rails db:reset
```

### Testing

```bash
# Tests ausführen
rails test

# Spezifische Tests
rails test test/models/
rails test test/controllers/
```

### Seeds

Die Seed-Datei erstellt Beispieldaten für Development und Testing:
- 2 Organisatoren
- 3 Spieler  
- 3 Beispiel-Matches
- 6 Teilnahme-Einträge

## Deployment

Für Produktionsumgebung:

1. Umgebungsvariablen setzen:
```bash
export RAILS_ENV=production
export SECRET_KEY_BASE=your-secret-key
```

2. Assets precompile:
```bash
rails assets:precompile
```

3. Datenbank migrieren:
```bash
rails db:migrate RAILS_ENV=production
```

## Projekt-Info

- **Modul**: Multiuser-Applikation
- **Autor**: Emilio Jordan
- **Klasse**: 23-223 E
- **Datum**: September 2025

## Architektur

Die Applikation folgt dem MVC-Pattern von Ruby on Rails:

- **Models**: User, Match, Participation mit ActiveRecord
- **Views**: ERB-Templates mit Bootstrap-Styling
- **Controllers**: Application, Sessions, Users, Matches, Participations
- **Routes**: RESTful routing mit nested resources

## Browser-Kompatibilität

- Chrome/Chromium (empfohlen)
- Firefox
- Safari
- Edge

Benötigt moderne Browser-Features für optimale Darstellung.
