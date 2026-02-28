# Mac App Store Submission Guide for HEXPal

This guide walks you through submitting HEXPal to the Mac App Store.

---

## Prerequisites Checklist

- [x] Apple Developer Account (you have one)
- [x] Development Team configured (`DV99BDRK7P`)
- [x] Bundle ID: `co.jamcreative.HexPal`
- [x] App Sandbox enabled
- [x] Hardened Runtime enabled
- [x] Code Signing: Automatic
- [ ] App Store Connect app record created
- [ ] Screenshots prepared
- [ ] App metadata prepared
- [ ] Archive created and uploaded

---

## Step 1: Configure Xcode for App Store Distribution

### 1.1 Verify Signing Configuration

1. **Open** `HexPal.xcodeproj` in Xcode
2. **Select** the HexPal project in the navigator
3. **Select** the HexPal target
4. **Go to** "Signing & Capabilities" tab
5. **Verify**:
   - ✅ Team: `DV99BDRK7P` (or your team name)
   - ✅ Bundle Identifier: `co.jamcreative.HexPal`
   - ✅ Signing Certificate: "Apple Distribution" (should auto-select)
   - ✅ Provisioning Profile: "Xcode Managed Profile" (should auto-create)

### 1.2 Verify Capabilities

**Required for App Store:**
- ✅ **App Sandbox**: Must be enabled (already enabled)
- ✅ **Hardened Runtime**: Must be enabled (already enabled)

**Your app needs these entitlements:**
- None beyond standard App Sandbox — no additional permissions required

**Check entitlements:**
1. In "Signing & Capabilities" tab
2. Click "+ Capability" if needed
3. Add "App Sandbox" if not present
4. Under App Sandbox, ensure:
   - ✅ User Selected File: Read Only (for future features)
   - ✅ Outgoing Connections: Not needed (app is local-only)

### 1.3 Verify Info.plist

Your `Info.plist` should have:
- ✅ `NSHumanReadableCopyright` (already present)
- ✅ `LSApplicationCategoryType`: `public.app-category.utilities` (already set in build settings)

**Note:** No usage description keys required — HEXPal uses NSColorSampler and KeyboardShortcuts, neither of which require privacy permissions.

---

## Step 2: Create App Record in App Store Connect

### 2.1 Access App Store Connect

1. Go to: https://appstoreconnect.apple.com
2. **Sign in** with your Apple Developer account
3. Click **"My Apps"**

### 2.2 Create New App

1. Click **"+"** button → **"New App"**
2. **Fill in the form:**
   - **Platform**: macOS
   - **Name**: HEXPal
   - **Primary Language**: English (U.S.)
   - **Bundle ID**: Select `co.jamcreative.HexPal` (or create it if needed)
   - **SKU**: `HEXPal-001` (unique identifier, can be anything)
   - **User Access**: Full Access (or Limited if you have a team)
3. Click **"Create"**

### 2.3 Configure App Information

**App Information Tab:**
- **Name**: HEXPal
- **Subtitle**: Pick any color. Get HEX. Instantly.
- **Category**: 
  - Primary: Utilities
  - Secondary: (optional) Developer Tools
- **Privacy Policy URL**: (optional, but recommended)
  - Example: `https://github.com/jamcreativeconsulting/HexPal/blob/main/PRIVACY.md`
- **Support URL**: `https://github.com/jamcreativeconsulting/HexPal/issues`
- **Marketing URL**: (optional) `https://github.com/jamcreativeconsulting/HexPal`

**Pricing and Availability:**
- **Price**: Free
- **Availability**: All countries (or select specific)

---

## Step 3: Prepare App Metadata

### 3.1 App Description

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

### 3.2 What's New in This Version

Use the content from `RELEASE_NOTES_APP_STORE.txt` (first 4000 characters).

---

## Step 4: Prepare Screenshots

### 4.1 Screenshot Requirements

**Required sizes for macOS:**
- **1280 x 800 pixels** (required)
- **1440 x 900 pixels** (optional)
- **2560 x 1600 pixels** (optional)
- **2880 x 1800 pixels** (optional)

**Minimum:** 1 screenshot required  
**Maximum:** 10 screenshots allowed

### 4.2 Screenshot Ideas

1. **Main Feature**: Menu bar icon with color picker active
2. **Notification**: Clipboard notification showing HEX code
3. **Preferences**: Preferences window showing hotkey customization
4. **Recent Colors**: Menu showing recent colors submenu
5. **Workflow**: Before/after showing color picked and HEX code copied

### 4.3 Creating Screenshots

**Option 1: Use macOS Screenshot Tool**
1. Launch HEXPal
2. Press `⌘⇧4` (screenshot tool)
3. Capture relevant UI elements
4. Edit in Preview or another tool

**Option 2: Use Xcode Simulator** (if applicable)
- Not applicable for menu bar apps

**Option 3: Design Mockups**
- Create mockups showing the app in action
- Use design tools (Figma, Sketch, etc.)

### 4.4 Screenshot Tips

- Show the app in action
- Highlight key features
- Use clean, uncluttered backgrounds
- Show macOS menu bar context
- Include visual examples of color picking

---

## Step 5: Create Archive and Upload

### 5.1 Clean Build Folder

1. In Xcode: **Product → Clean Build Folder** (Shift+Cmd+K)
2. Wait for cleanup

### 5.2 Create Archive

1. **Product → Scheme → HexPal** (verify selected)
2. **Product → Destination → Any Mac** (or "My Mac")
3. **Product → Archive**
4. Wait for archive to complete (2-5 minutes)
5. Organizer window opens automatically

### 5.3 Distribute to App Store

1. In Organizer, **select your archive**
2. Click **"Distribute App"**
3. Choose **"App Store Connect"**
4. Click **"Next"**
5. Choose **"Upload"** (not Export)
6. Click **"Next"**
7. **Select options:**
   - ✅ Upload your app's symbols (for crash reports)
   - ✅ Manage version and build number (if needed)
8. Click **"Next"**
9. **Review signing:**
   - Should show "Apple Distribution" certificate
   - Should show "Xcode Managed Profile"
10. Click **"Upload"**
11. Wait for upload to complete (may take 5-15 minutes)

### 5.4 Verify Upload

1. Go to **App Store Connect**
2. Navigate to your app
3. Go to **"TestFlight"** tab (or "App Store" → "Build")
4. Wait for processing (can take 10-30 minutes)
5. Once processed, you'll see the build listed

---

## Step 6: Complete App Store Listing

### 6.1 Add Screenshots

1. In App Store Connect, go to your app
2. Click **"App Store"** tab
3. Select **"macOS App"** (or your version)
4. Scroll to **"Screenshots"**
5. **Drag and drop** your screenshots
6. Add captions if desired

### 6.2 Add App Information

1. Fill in all required fields:
   - Name
   - Subtitle
   - Description
   - Keywords
   - Support URL
   - Category
   - Copyright
   - Age Rating

### 6.3 Age Rating

1. Click **"Age Rating"**
2. Answer the questionnaire:
   - **Unrestricted Web Access**: No (app doesn't access web)
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

### 6.4 Pricing and Availability

1. Set price: **Free**
2. Select availability: **All countries** (or specific)
3. Save

---

## Step 7: Submit for Review

### 7.1 Select Build

1. In App Store Connect, go to your app
2. Click **"App Store"** tab
3. Scroll to **"Build"** section
4. Click **"+"** next to Build
5. **Select** your uploaded build
6. Click **"Done"**

### 7.2 Export Compliance

**Question:** "Does your app use encryption?"

**Answer:** 
- **No** (if app doesn't use encryption APIs)
- **Yes** (if app uses HTTPS or encryption - even standard macOS encryption)

For HEXPal, likely **"No"** since it's a local-only app.

### 7.3 Advertising Identifier

**Question:** "Does this app use the Advertising Identifier (IDFA)?"

**Answer:** **No** (HEXPal doesn't use advertising)

### 7.4 Content Rights

**Question:** "Do you have the rights to use all content in your app?"

**Answer:** **Yes** (you own the code, it's open source)

### 7.5 Submit for Review

1. **Review** all information
2. Click **"Add for Review"** or **"Submit for Review"**
3. **Confirm** submission
4. Status changes to **"Waiting for Review"**

---

## Step 8: Review Process

### 8.1 Review Timeline

- **Initial Review**: 24-48 hours typically
- **Re-review** (if changes needed): 24-48 hours
- **Total**: Usually 1-3 days for first submission

### 8.2 Common Rejection Reasons

**For menu bar apps:**
- Unnecessary usage description keys in Info.plist (HEXPal needs none)
- App doesn't function as described
- Missing app icon (may be required)
- Privacy policy missing (if collecting data)

**HEXPal should be fine** since:
- ✅ No privacy permissions required
- ✅ Functions as described
- ✅ Doesn't collect data
- ✅ Open source

### 8.3 If Rejected

1. **Read** rejection reason carefully
2. **Fix** the issue
3. **Create new archive** with fix
4. **Upload** new build
5. **Resubmit** for review

---

## Step 9: Post-Submission

### 9.1 Monitor Status

- Check App Store Connect regularly
- Watch for review updates
- Respond to any questions from Apple

### 9.2 After Approval

- App goes live automatically (if set to auto-release)
- Or manually release when ready
- Monitor for user feedback
- Watch for crash reports

---

## Troubleshooting

### Archive Fails

**Error:** "No signing certificate found"
- **Solution**: Go to Xcode → Preferences → Accounts → Download Manual Profiles

**Error:** "Provisioning profile not found"
- **Solution**: Let Xcode manage profiles automatically, or create in App Store Connect

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

## Quick Checklist

Before submitting:

- [ ] App builds and runs successfully
- [ ] Code signing configured correctly
- [ ] App Sandbox enabled
- [ ] Hardened Runtime enabled
- [ ] Usage descriptions in Info.plist
- [ ] App Store Connect app created
- [ ] Screenshots prepared
- [ ] App metadata filled in
- [ ] Age rating completed
- [ ] Build uploaded successfully
- [ ] Build selected in App Store listing
- [ ] Ready to submit for review

---

## Next Steps After Submission

1. **Monitor** App Store Connect for review status
2. **Respond** to any questions from Apple reviewers
3. **Prepare** marketing materials (if desired)
4. **Update** GitHub README with App Store link (once approved)
5. **Monitor** user reviews and feedback

---

**Good luck with your submission! 🚀**
