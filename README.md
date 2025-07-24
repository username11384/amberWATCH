# amberWATCH
Amber Electric live spot prices on Apple Watch

# How to Build
This is for watchOS11.4, but you can change the target in xcode. Go to the project settings and then target and change the bundle identifier and team to your apple ID. I suck at writing build instructions by the way. Anyways, this app shows the live spot price and the live FiT with the Amber API. Go to DataStore.swift and change the apiKey and the SiteId to your API and Site ID. You can get the site id with 

```curl -H "Authorization: Bearer YOUR_API_KEY"```

Build and then hope it works. If there's something wrong just add a GitHub issue and I'll fix it

# Features
Live spot and FiT prices
Price forecast graph and table

# Screenshots
