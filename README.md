# 🎨 Pussy Station
...
A cross-platform web application for art academy management, featuring a unique **8-bit pixel art** and **Paris Metro** aesthetic.

![Painter Hero](https://github.com/user-attachments/assets/logo-placeholder.png) <!-- Reemplazar con imagen real si se desea -->

## 🛡️ Features

- **8-Bit Aesthetic**: Retro visuals with "Press Start 2P" typography and vibrant "Art Dungeon" colors.
- **Hero-Based Management**: Students are treated as heroes with unique training schedules.
- **Drag & Drop Calendar**: Interactive class recovery system where classes can be moved between days.
- **Real-Time Dungeon Logs**: Instant notifications when slots are released or settings are changed.
- **Admin God Mode**: Full CRUD control over students and global recovery limits.

## 🛠️ Tech Stack

- **Frontend**: Flutter Web
- **Backend**: Supabase (Database, Auth, Realtime)
- **Deployment**: Vercel

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (latest stable)
- A Supabase project

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/PaintingHero.git
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Initialize the database:
   - Run the SQL script found in `implementation_plan.md` in your Supabase SQL Editor.
4. Update credentials:
   - Edit `lib/main.dart` with your `SUPABASE_URL` and `SUPABASE_ANON_KEY`.

### Running Locally

```bash
flutter run -d chrome
```

## 📜 License

This project is licensed under the MIT License.
