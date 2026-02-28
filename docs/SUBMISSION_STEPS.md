# HEXPal Mac App Store Submission - Step-by-Step Guide

**Current Status:** Ready to submit  
**Date:** January 2025

---

## ✅ Pre-Submission Checklist

### 1. Project Configuration ✅
- [x] Bundle ID: `co.jamcreative.HexPal`
- [x] Version: 1.0
- [x] Build: 1
- [x] Team: `DV99BDRK7P`
- [x] App Sandbox: Enabled
- [x] Hardened Runtime: Enabled
- [x] Usage descriptions in Info.plist ✅

### 2. Code Signing
- [ ] **Apple Distribution certificate created** (see FIX_SIGNING_CERTIFICATE.md)
- [ ] Certificate visible in Xcode Signing & Capabilities
- [ ] Automatic signing enabled

### 3. App Store Connect
- [ ] App record created
- [ ] Bundle ID registered
- [ ] App metadata prepared

---

## Step 1: Create Apple Distribution Certificate

**If you haven't done this yet:**

1. **Xcode → Settings → Accounts**
2. Select your Apple ID
3. Select your team (`DV99BDRK7P`)
4. Click **"Manage Certificates..."**
5. Click **"+"** → **"Apple Distribution"**
6. Click **"Done"**

**Verify:**
```bash
security find-identity -v -p codesigning | grep "Apple Distribution"
```

Should show: `"Apple Distribution: Your Name (TEAM_ID)"`

---

## Step 2: Verify Xcode Project Configuration

1. **Open** `HexPal.xcodeproj` in Xcode
2. **Select** HexPal project (top of navigator)
3. **Select** HexPal target
4. **Go to** "Signing & Capabilities" tab
5. **Verify:**
   - ✅ Team: `DV99BDRK7P`
   - ✅ Bundle Identifier: `co.jamcreative.HexPal`
   - ✅ "Automatically manage signing" is **checked**
   - ✅ Signing Certificate: Should show **"Apple Distribution"** (or will when archiving)
   - ✅ Provisioning Profile: "Xcode Managed Profile"

**If certificate doesn't show:**
- Try Product → Clean Build Folder
- Restart Xcode
- Check that certificate exists (Step 1)

---

## Step 3: Create App Record in App Store Connect

### 3.1 Access App Store Connect

1. Go to: **https://appstoreconnect.apple.com**
2. **Sign in** with your Apple Developer account
3. Click **"My Apps"**

### 3.2 Create New App

1. Click **"+"** button (top left) → **"New App"**
2. **Fill in:**
   - **Platform**: macOS
   - **Name**: HEXPal
   - **Primary Language**: English (U.S.)
   - **Bundle ID**: Select `co.jamcreative.HexPal` (or create if needed)
   - **SKU**: `HEXPal-001` (unique identifier, can be anything)
   - **User Access**: Full Access
3. Click **"Create"**

### 3.3 Register Bundle ID (if needed)

If bundle ID doesn't exist:
1. Go to: **https://developer.apple.com/account/resources/identifiers/list**
2. Click **"+"**
3. Select **"App IDs"**
4. Select **"App"**
5. **Description**: HEXPal
6. **Bundle ID**: `co.jamcreative.HexPal`
7. **Capabilities**: App Sandbox (should auto-select)
8. Click **"Continue"** → **"Register"**

---

## Step 4: Prepare App Metadata

### 4.1 App Information

**Name**: HEXPal

**Subtitle** (up to 30 characters):
```
Pick any color. Get HEX. Instantly.
```

**Description** (up to 4000 characters):
```
HEXPal is a free, open-source macOS menu bar application for quickly picking colors and getting HEX codes. Built with Swift and AppKit, optimized for speed and simplicity.

✨ Features

• Color Picking - Pick any color from your screen with Apple's native color picker. Works system-wide across all applications and windows.

• HEX Codes - Automatically copy HEX codes to clipboard in #RRGGBB format. Ready to paste into your code or design tools instantly.

• Global Hotkey - Activate from anywhere with ⌘⇧P (customizable). Works from any application without switching windows.

• Recent Colors - Quick access to your last 10 picked colors with visual swatches. One-click copy to clipboard.

• Multi-Monitor Support - Works seamlessly across all displays. Automatically detects the active screen.

• Modern Notifications - Clean, non-intrusive clipboard confirmations with smooth animations.

• Preferences - Customize your hotkey and enable launch at login (macOS 13+). All settings persist across launches.

🚀 Getting Started

1. Press ⌘⇧P or click the menu bar icon to activate
2. Move your cursor over any color and click to select
3. HEX code is automatically copied to clipboard
4. Paste with ⌘V wherever you need it

📋 Requirements

• macOS 10.15 (Catalina) or later
• Zero permissions required

HEXPal is free and open source forever. No paywalls, no subscriptions.

Built with ❤️ for developers and designers who need HEX codes fast.
```

**Keywords** (up to 100 characters, comma-separated):
```
color picker,hex code,color tool,design tool,developer tool,menu bar,utility,color palette,clipboard
```

**Promotional Text** (optional, up to 170 characters):
```
Free, open-source color picker for macOS. Get HEX codes instantly with a global hotkey. Perfect for developers and designers.
```

**Support URL**: `https://github.com/jamcreativeconsulting/HexPal/issues`

**Marketing URL** (optional): `https://github.com/jamcreativeconsulting/HexPal`

**Privacy Policy URL** (optional but recommended):
`https://github.com/jamcreativeconsulting/HexPal/blob/main/PRIVACY.md`

### 4.2 Category

- **Primary**: Utilities
- **Secondary**: (optional) Developer Tools

### 4.3 Pricing

- **Price**: Free
- **Availability**: All countries (or select specific)

---

## Step 5: Prepare Screenshots

### 5.1 Screenshot Requirements

**Required sizes:**
- **1280 x 800 pixels** (minimum required)
- **1440 x 900 pixels** (optional)
- **2560 x 1600 pixels** (optional)
- **2880 x 1800 pixels** (optional)

**Minimum:** 1 screenshot required  
**Maximum:** 10 screenshots allowed

### 5.2 Screenshot Ideas

1. **Main Feature**: Menu bar icon with color picker active
2. **Notification**: Clipboard notification showing HEX code
3. **Preferences**: Preferences window showing hotkey customization
4. **Recent Colors**: Menu showing recent colors submenu
5. **Workflow**: Before/after showing color picked and HEX code copied

### 5.3 Creating Screenshots

**Quick Method:**
1. Launch HEXPal
2. Press `⌘⇧4` (macOS screenshot tool)
3. Capture relevant UI elements
4. Edit in Preview if needed

**Tips:**
- Show the app in action
- Highlight key features
- Use clean, uncluttered backgrounds
- Show macOS menu bar context

---

## Step 6: Create Archive Build

### 6.1 Clean Build

1. In Xcode: **Product → Clean Build Folder** (Shift+Cmd+K)
2. Wait for cleanup to complete

### 6.2 Set Archive Scheme

1. **Product → Scheme → HexPal** (verify selected)
2. **Product → Destination → Any Mac** (or "My Mac")

### 6.3 Create Archive

1. **Product → Archive**
2. Wait for archive to complete (2-5 minutes)
3. **Organizer window opens automatically**

**If archive fails:**
- Check that Apple Distribution certificate exists
- Verify signing configuration
- Try Product → Clean Build Folder again

---

## Step 7: Upload to App Store Connect

### 7.1 Distribute Archive

1. In **Organizer**, select your archive
2. Click **"Distribute App"**
3. Choose **"App Store Connect"**
4. Click **"Next"**
5. Choose **"Upload"** (not Export)
6. Click **"Next"**

### 7.2 Select Options

- ✅ **Upload your app's symbols** (for crash reports)
- ✅ **Manage version and build number** (if needed)
- Click **"Next"**

### 7.3 Review Signing

**Should show:**
- ✅ Signing Certificate: **"Apple Distribution"**
- ✅ Provisioning Profile: "Xcode Managed Profile" or "Mac App Store"

**If errors:**
- Check certificate exists
- Verify team is selected
- Try downloading manual profiles

### 7.4 Upload

1. Click **"Upload"**
2. Wait for upload to complete (5-15 minutes)
3. **Don't close Xcode** during upload

### 7.5 Verify Upload

1. Go to **App Store Connect**
2. Navigate to your app
3. Go to **"TestFlight"** tab (or "App Store" → "Build")
4. Wait for processing (10-30 minutes)
5. Once processed, build will appear in list

**Status indicators:**
- **Processing**: Build is being validated
- **Ready to Submit**: Build is ready
- **Invalid Binary**: Check error messages

---

## Step 8: Complete App Store Listing

### 8.1 Add Screenshots

1. In App Store Connect, go to your app
2. Click **"App Store"** tab
3. Select **"macOS App"** (or your version)
4. Scroll to **"Screenshots"**
5. **Drag and drop** your screenshots
6. Add captions if desired

### 8.2 Add App Information

1. Fill in all required fields:
   - Name ✅
   - Subtitle ✅
   - Description ✅
   - Keywords ✅
   - Support URL ✅
   - Category ✅
   - Copyright ✅

### 8.3 Age Rating

1. Click **"Age Rating"**
2. Answer questionnaire:
   - **Unrestricted Web Access**: No
   - **Gambling**: No
   - **Contests**: No
   - **Crude Humor**: No
   - **Horror/Fear Themes**: No
   - **Mature/Suggestive Themes**: No
   - **Medical/Treatment Information**: No
   - **Profanity or Crude Humor**: No
   - **Sexual Content or Nudity**: No
   - **Violence**: No
   - **Alcohol, Tobacco, or Drugs**: No
   - **Weapons**: No
3. Should result in **4+** rating

### 8.4 Pricing and Availability

1. Set price: **Free**
2. Select availability: **All countries** (or specific)
3. Save

---

## Step 9: Select Build and Submit

### 9.1 Select Build

1. In App Store Connect, go to your app
2. Click **"App Store"** tab
3. Scroll to **"Build"** section
4. Click **"+"** next to Build
5. **Select** your uploaded build (should show version 1.0, build 1)
6. Click **"Done"**

### 9.2 Export Compliance

**Question:** "Does your app use encryption?"

**Answer:** 
- **No** (HEXPal is local-only, doesn't use encryption APIs)

### 9.3 Advertising Identifier

**Question:** "Does this app use the Advertising Identifier (IDFA)?"

**Answer:** **No** (HEXPal doesn't use advertising)

### 9.4 Content Rights

**Question:** "Do you have the rights to use all content in your app?"

**Answer:** **Yes** (you own the code, it's open source)

### 9.5 Submit for Review

1. **Review** all information
2. Click **"Add for Review"** or **"Submit for Review"**
3. **Confirm** submission
4. Status changes to **"Waiting for Review"**

---

## Step 10: Review Process

### 10.1 Timeline

- **Initial Review**: 24-48 hours typically
- **Re-review** (if changes needed): 24-48 hours
- **Total**: Usually 1-3 days for first submission

### 10.2 Monitor Status

- Check App Store Connect regularly
- Watch for review updates
- Respond to any questions from Apple

### 10.3 Common Rejection Reasons

**For menu bar apps:**
- Unnecessary usage description keys in Info.plist (none present — correct for HEXPal)
- App doesn't function as described
- Missing app icon (may be required)

**HEXPal should be fine** since:
- ✅ No privacy permissions required (NSColorSampler, KeyboardShortcuts)
- ✅ Functions as described
- ✅ Doesn't collect data
- ✅ Open source

### 10.4 If Rejected

1. **Read** rejection reason carefully
2. **Fix** the issue
3. **Create new archive** with fix
4. **Upload** new build
5. **Resubmit** for review

---

## Step 11: After Approval

### 11.1 Release

- App goes live automatically (if set to auto-release)
- Or manually release when ready

### 11.2 Post-Release

- Monitor user reviews
- Watch for crash reports
- Update GitHub README with App Store link
- Prepare for future updates

---

## Quick Reference

### Important URLs

- **App Store Connect**: https://appstoreconnect.apple.com
- **Apple Developer Portal**: https://developer.apple.com/account
- **Certificates**: https://developer.apple.com/account/resources/certificates/list
- **Bundle IDs**: https://developer.apple.com/account/resources/identifiers/list

### Key Information

- **Bundle ID**: `co.jamcreative.HexPal`
- **Team ID**: `DV99BDRK7P`
- **Version**: 1.0
- **Build**: 1
- **Category**: Utilities

---

## Troubleshooting

### Archive Fails

**Error:** "No signing certificate found"
- **Solution**: Create Apple Distribution certificate (Step 1)

**Error:** "Provisioning profile not found"
- **Solution**: Enable "Automatically manage signing" in Xcode

### Upload Fails

**Error:** "Invalid bundle"
- **Solution**: Check bundle ID matches App Store Connect exactly

**Error:** "Missing required icon"
- **Solution**: Add app icon to Assets.xcassets (see APP_ICON_GUIDE.md)

### Build Processing Fails

**Error:** "Invalid binary"
- **Solution**: Check that App Sandbox is enabled
- **Solution**: Verify Hardened Runtime is enabled
- **Solution**: Check entitlements are correct

---

**Good luck with your submission! 🚀**
