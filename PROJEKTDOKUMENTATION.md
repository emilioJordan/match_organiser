# Projektdokumentation - Match Organiser
## Modul 223: Multi-User-Applikationen objektorientiert realisieren

**Name:** Emilio Jordan  
**Kurs:** 23-223 E  
**Datum:** 26.09.2025  
**PC-Nr:** [214]

---

## 1. Projektqualität (8 Punkte)

### Konventionen (Code, Dateinamen, Frameworks etc.)
- **Rails-Konventionen**: MVC-Pattern korrekt implementiert
- **Namenskonventionen**: CamelCase für Klassen, snake_case für Variablen und Methoden
- **Dateistruktur**: Standard Rails-Verzeichnisstruktur eingehalten
- **Framework**: Ruby on Rails 8.0.3 mit SQLite3

### Applikation ist lauffähig und erfüllt die Anforderungen
- Benutzerregistrierung und -authentifizierung
- Rollenbasierte Zugriffskontrolle (Organizer/Player)
- CRUD-Operationen für Matches
- Teilnahme-Management System
- Multiuser-fähige Architektur

### Abschlusspräsentation
- Live-Demo der funktionsfähigen Applikation
- Erklärung der Architektur und Funktionalitäten
- Demonstration aller Benutzerrollen

## 2. Domänenmodell und Architektur (8 Punkte)

### Anforderungen berücksichtigt
- **Problemstellung**: Organisation von Freizeitspielen
- **Zielgruppe**: Sportgruppen mit verschiedenen Rollen
- **Multiuser-Aspekt**: Gleichzeitige Nutzung durch mehrere Benutzer

### Domänenspezifische Fachbegriffe verwendet
```ruby
# Entitäten der Domäne
class User < ApplicationRecord      # Benutzer/Spieler
class Match < ApplicationRecord     # Sportspiel/Event
class Participation < ApplicationRecord  # Teilnahme
```

### Implementation entspricht Dokumentation

#### Entity-Relationship-Model (ERM):
```
User (1) ----< (n) Match  [created_by]
User (n) ----< (n) Match  [via Participation]
```

#### Datenmodell:
- **User**: id, name, email, password_digest, role
- **Match**: id, title, description, date, time, location, created_by_id
- **Participation**: id, user_id, match_id, status

## 3. Multi-User-Applikation (14 Punkte)

### Authentifizierung
```ruby
# has_secure_password für sichere Authentifizierung
class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true
end

# Session-basierte Authentifizierung
class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path
    end
  end
end
```

### Benutzerprofil
- Benutzerregistrierung mit Rollenwahl
- Profilansicht mit erstellten/teilgenommenen Matches
- Sichere Passwort-Speicherung

### Benutzerverwaltung
- Rollenbasierte Berechtigungen (Organizer/Player)
- Benutzer können nur eigene Matches bearbeiten
- Öffentliche Profilansicht

### Benutzerrollen und Berechtigungen
```ruby
# Autorisierung im Controller
class MatchesController < ApplicationController
  before_action :require_organizer, only: [:new, :create, :edit, :update, :destroy]
  
  private
  
  def require_organizer
    unless current_user.organizer?
      flash[:alert] = "Nur Organisatoren können Matches verwalten"
      redirect_to matches_path
    end
  end
end
```

### Aktivitätsprotokoll
- Flash-Messages für Benutzeraktionen
- Session-Management
- Redirect-Logs in Rails-Konsole

### Fehlerbehandlung und User Feedback
```ruby
# Validierungen mit Fehlermeldungen
class Match < ApplicationRecord
  validates :title, presence: true
  validates :date, presence: true
  validates :location, presence: true
end

# Flash-Messages in Views
<% if flash.any? %>
  <% flash.each do |type, message| %>
    <div class="alert alert-<%= type == 'notice' ? 'success' : 'danger' %>">
      <%= message %>
    </div>
  <% end %>
<% end %>
```

### Kernfunktion (domänen-spezifische Funktionalität und Benutzerschnittstelle)
- **Match-Erstellung**: Organisatoren können Events erstellen
- **Teilnahme-Management**: Spieler können zu-/absagen
- **Live-Updates**: Teilnehmerliste wird in Echtzeit aktualisiert
- **Responsive Design**: Bootstrap-basierte Benutzeroberfläche

## 4. Technische Implementation

### Datenbank-Schema
```ruby
# Migration für Users
class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false, unique: true
      t.string :password_digest, null: false
      t.string :role, null: false
      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end

# Migration für Matches
class CreateMatches < ActiveRecord::Migration[8.0]
  def change
    create_table :matches do |t|
      t.string :title, null: false
      t.text :description
      t.date :date, null: false
      t.time :time, null: false
      t.string :location, null: false
      t.references :created_by, null: false, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end
```

### Model-Beziehungen
```ruby
class User < ApplicationRecord
  has_many :created_matches, class_name: 'Match', foreign_key: 'created_by_id'
  has_many :participations
  has_many :matches, through: :participations
end

class Match < ApplicationRecord
  belongs_to :created_by, class_name: 'User'
  has_many :participations
  has_many :participants, through: :participations, source: :user
end
```

### RESTful Routes
```ruby
Rails.application.routes.draw do
  resources :matches do
    resources :participations, only: [:create, :update, :destroy]
  end
  resources :users, only: [:show]
  
  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  root 'matches#index'
end
```

## 5. Sicherheitsaspekte

- **Passwort-Verschlüsselung**: BCrypt für sichere Passwort-Speicherung
- **Session-Sicherheit**: Rails-Session-Management
- **CSRF-Schutz**: Automatisch durch Rails aktiviert
- **Input-Validierung**: Serverseitige Validierung aller Eingaben
- **Autorisierung**: Rollenbasierte Zugriffskontrolle

## 6. Fazit

Die Match Organiser Applikation erfüllt alle Anforderungen einer Multi-User-Applikation:
- Saubere objektorientierte Architektur
- Rollenbasierte Benutzerverwaltung
- Domänenspezifische Funktionalitäten
- Sichere Authentifizierung und Autorisierung
- Responsive und benutzerfreundliche Oberfläche

Die Applikation löst das reale Problem der Sportgruppen-Organisation und bietet eine moderne, webbasierte Lösung.