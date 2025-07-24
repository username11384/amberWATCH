# amberWATCH
unofficial Amber Electric Apple Watch app!

# How to Build
This is for watchOS11.4, but you can change the target in xcode. Go to the project settings and then target and change the bundle identifier and team to your apple ID. I suck at writing build instructions by the way. Anyways, this app shows the live spot price and the live FiT with the Amber API. Go to DataStore.swift and change the apiKey and the SiteId to your API and Site ID. You can get the site id with 

```curl -H "Authorization: Bearer YOUR_API_KEY"```

Build and then hope it works. If there's something wrong just add a GitHub issue and I'll fix it

# Features
Live spot and FiT prices
Price forecast graph and table

# Screenshots
<img width="352" height="430" alt="Simulator Screenshot - IL watch virtual - 2025-07-24 at 20 58 52" src="https://github.com/user-attachments/assets/d0a3d719-9893-4b21-a558-0ccc9fe02384" />
https://github.com/user-attachments/assets/fde96d36-33ed-4c1a-95f6-f0e4b236b97f



Thanks to the Amber Electric team for providing the API!
