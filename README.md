# ![Awakener's Orb](https://web.poecdn.com/image/Art/2DItems/Currency/TransferOrb.png) Geforce NOW **bridge** for Awakened PoE Trade

![kHBPqWXHkQ31](https://github.com/KloppstockBw/GFNPoEPriceCheck/assets/147773628/7cce82ba-5422-4154-abbd-789d80afc0a1)
### reddit
https://www.reddit.com/r/pathofexile/comments/17cktr0/awakened_poe_trade_on_geforce_now/?utm_source=share&utm_medium=mweb

### Hotkey Usage

| F5 | F6 | F7 | F9 | F11 |
|-----|------|--------|----------|----------|
| goto hideout | price check | open steam overlay | send thanks in local chat | force close script |

### Requirements

-  [GFNPoEPriceCheck.au3](Https://github.com/KloppstockBw/GFNPoEPriceCheck/blob/main/GFNPoEPriceCheck.au3)
  (Alternatively the [GFNPoEPriceCheck.exe](https://github.com/KloppstockBw/GFNPoEPriceCheck/blob/main/GFNPoEPriceCheck.exe) , but you get a smartscreen warning the first run because I'm not going to buy a certificate to sign the exe as trustworthy)
  
- Autoit (Only if you use the .au3 Version) https://www.autoitscript.com/site/autoit/downloads/
  
- Awakened POE Trade
  https://github.com/SnosMe/awakened-poe-trade

- Path of exile for **Steam** in Geforce NOW (GGG Version does not work) 

### Features

- No need to change Awakened PoE Trade settings
- Copy Item Details in background (except in GeForce NOW) 
- config file in documents/mygames/Path Of EXILE containing:
  - URL to google.docs
  - Mouse position to paste item details in GFN
  - Auto start awakened Poe trade if wanted
- more to come - I welcome any ideas

### Install
**Video Guide** 
https://www.youtube.com/watch?v=K87GRUXJLl0

1. Create a https://docs.google.com/document/create document and activate share to everyone.
2. Run awakened PoE trade
3. Run GFNPoEPriceCheck
4. Decide in script if you want to autorun awakened on script start (recommended)
5. Show the script where the awakened PoE trade input field is
6. tell the script your docs.google URL
7. Change default Website in Steam overlay to the created docs.google.com URL .
8. Set Steam overlay default key to F7
9. Have fun price checking in GeForce NOW

### to do 
- troubleshooting
- Gui to change config and stuff
  
### How it works - short story

- it asks the user for various inputs and safes them to config file
- if the config files contains value it skips the inputs
- in gfn it sends the item details to the steam build in browser where the home page is set to the docs google by the user
- on local PC the scrips reads the docs google site content and copy it to the clipboard
- the scrips renames the gfn window to "Path of exile" so the awakened tool detects it as poe
- finally the scripts copys the data to awakened inside of gfn poe
