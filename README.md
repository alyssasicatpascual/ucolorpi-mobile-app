A Flutter-based frontend UI prototype for the U-COLORPI system, developed using mock data and focused solely on layout, navigation, and user experience without backend integration. 

STEPS TO RUN
Step 1: Fork the Repository
This creates a copy of the project under your own GitHub account so you can make changes without affecting the main project immediately.

1. Go to the main GitHub repository URL for ucolorpi-app (e.g., the one owned by your project lead).
2. Click the Fork button in the top-right corner of the page.
3. Select your GitHub account as the destination.
4. You now have a copy at https://github.com/YOUR-USERNAME/ucolorpi-app.

Step 2: Clone the Repository
This downloads the code from your forked repository to your local computer.

1. On your forked repository page, click the green <> Code button.
2. Copy the HTTPS URL (e.g., https://github.com/YOUR-USERNAME/ucolorpi-app.git).
3. Open a terminal (Command Prompt, PowerShell, or Terminal).
4. Navigate to the folder where you want to save the project (e.g., cd Documents).
5. Run the clone command: git clone https://github.com/YOUR-USERNAME/ucolorpi-app.git

Step 3: Open in VS Code & Install Dependencies
1. Open VS Code.
2. Go to File > Open Folder...
3. Select the ucolorpi-app folder you just cloned.
4. Open the Integrated Terminal in VS Code (`Ctrl + `` or Terminal > New Terminal).
5. Download the necessary Flutter packages (like flutter_svg, firebase_auth, etc.) by running:
flutter pub get

Step 4: Create a Feature Branch
Never work directly on the main or master branch. Always create a specific branch for the feature you are building.

1. In the VS Code terminal, make sure you are on the main branch:
git checkout main
git pull origin main  # Ensures you have the latest code
2. Create and switch to a new branch for your specific task (e.g., fixing-login-screen or create-profile-page):
git checkout -b feature/your-feature-name
(You are now working in an isolated environment. Changes here won't break the main app until you merge them.)

Step 5: Connect Your Mobile Phone (Android)
1. Enable Developer Options:
- Go to Settings > About Phone.
- Tap Build Number 7 times until it says "You are now a developer."
2. Enable USB Debugging:
- Go to Settings > System > Developer Options.
- Turn on USB Debugging.
3. Connect via USB:
4. Plug your phone into your computer.
5. Look at your phone screen; a prompt will appear asking to "Allow USB debugging?". Check "Always allow" and tap Allow.

Step 6: Select Device & Run
1. Look at the bottom-right corner of VS Code. You should see your device name (e.g., Samsung SM-A50...).
2. If it says "No Device," click it and select your phone from the list.
3. Run the app by typing the following command in the terminal:
flutter run

Wait for the Gradle build to complete. The app will launch on your phone.
