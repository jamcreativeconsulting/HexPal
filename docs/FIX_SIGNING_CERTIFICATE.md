# Fix: Missing Apple Distribution Certificate

If you only see "Development" certificates in Xcode but need "Apple Distribution" for App Store submission, follow these steps.

---

## Solution: Create Apple Distribution Certificate

### Option 1: Automatic (Recommended - Easiest)

**Let Xcode create it automatically:**

1. **Open** `HexPal.xcodeproj` in Xcode
2. **Select** the HexPal project in navigator
3. **Select** the HexPal target
4. **Go to** "Signing & Capabilities" tab
5. **Check** "Automatically manage signing"
6. **Select** your Team from the dropdown
7. **Xcode will automatically:**
   - Create Apple Distribution certificate (if needed)
   - Create provisioning profile
   - Configure everything

**If it still doesn't work**, try:
- **Product → Clean Build Folder** (Shift+Cmd+K)
- **Close and reopen** Xcode
- **Try again** - Xcode should prompt to create the certificate

---

### Option 2: Manual Creation via Xcode Preferences

1. **Xcode → Settings** (or Preferences)
2. **Accounts** tab
3. **Select** your Apple ID
4. **Select** your team
5. **Click** "Manage Certificates..."
6. **Click** "+" button (bottom left)
7. **Select** "Apple Distribution"
8. **Click** "Done"
9. **Xcode will create** the certificate automatically

---

### Option 3: Manual Creation via Apple Developer Portal

If Xcode automatic creation doesn't work:

1. **Go to** https://developer.apple.com/account/resources/certificates/list
2. **Sign in** with your Apple Developer account
3. **Click** "+" button (top left)
4. **Select** "Mac App Distribution" (under Software)
5. **Click** "Continue"
6. **Follow** the instructions to create a Certificate Signing Request (CSR):
   - Open **Keychain Access** (Applications → Utilities)
   - **Keychain Access → Certificate Assistant → Request a Certificate from a Certificate Authority**
   - Enter your email and name
   - Select "Saved to disk"
   - Click "Continue"
   - Save the CSR file
7. **Upload** the CSR file in the Apple Developer portal
8. **Download** the certificate
9. **Double-click** the downloaded certificate to install it in Keychain
10. **Return to Xcode** and refresh certificates:
    - Xcode → Settings → Accounts
    - Select your team
    - Click "Download Manual Profiles" (if available)
    - Or restart Xcode

---

## Verify Certificate is Installed

### Check in Terminal:

```bash
security find-identity -v -p codesigning | grep "Apple Distribution"
```

You should see something like:
```
1) ABC123DEF456 "Apple Distribution: Your Name (TEAM_ID)"
```

### Check in Xcode:

1. **Xcode → Settings → Accounts**
2. **Select** your Apple ID
3. **Select** your team
4. **Click** "Manage Certificates..."
5. **Look for** "Apple Distribution" certificate
6. Should show status: "Valid"

---

## After Certificate is Created

### Configure Xcode Project:

1. **Select** HexPal project in navigator
2. **Select** HexPal target
3. **Signing & Capabilities** tab
4. **Verify:**
   - ✅ Team: Your team selected
   - ✅ Bundle Identifier: `co.jamcreative.HexPal`
   - ✅ Signing Certificate: Should now show "Apple Distribution"
   - ✅ Provisioning Profile: Should show "Xcode Managed Profile" or "Mac App Store"

### If Still Not Showing:

1. **Uncheck** "Automatically manage signing"
2. **Check** it again
3. **Select** your team again
4. **Xcode should refresh** and show the certificate

---

## Troubleshooting

### Certificate Still Not Appearing

**Try these steps:**

1. **Clean Xcode caches:**
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData
   ```

2. **Restart Xcode**

3. **Check Keychain Access:**
   - Open **Keychain Access**
   - Look in **"login"** keychain
   - Search for "Apple Distribution"
   - If found but Xcode doesn't see it:
     - Right-click certificate → **Get Info**
     - Check "Trust" settings
     - Set to "Use System Defaults"

4. **Re-download certificates:**
   - Xcode → Settings → Accounts
   - Select team → Click "Download Manual Profiles"
   - Or click "Manage Certificates" → Refresh

### "No Valid Signing Certificate" Error

**Solution:**
- Make sure you're signed in with the correct Apple ID in Xcode
- Verify your Apple Developer account is active
- Check that your team has the correct permissions
- Try creating the certificate manually via Apple Developer portal

### Certificate Expired

**Solution:**
- Create a new Apple Distribution certificate
- Old certificates expire after 1 year
- Xcode should prompt to renew automatically

---

## Quick Checklist

- [ ] Apple Developer account active
- [ ] Signed into Xcode with correct Apple ID
- [ ] Team selected in Xcode project
- [ ] "Automatically manage signing" checked
- [ ] Apple Distribution certificate exists (check Keychain or Developer portal)
- [ ] Xcode can see the certificate (check Signing & Capabilities)

---

## Next Steps

Once you have the Apple Distribution certificate:

1. ✅ Verify it shows in Xcode Signing & Capabilities
2. ✅ Create archive (Product → Archive)
3. ✅ Distribute to App Store Connect
4. ✅ Follow APP_STORE_SUBMISSION.md guide

---

**If you're still having issues**, the most reliable method is **Option 3** (manual creation via Apple Developer portal), as it gives you full control over the certificate creation process.
