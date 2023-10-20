# under construction - will be finished until November 2023


# ![Awakener's Orb](https://web.poecdn.com/image/Art/2DItems/Currency/TransferOrb.png) Geforce NOW **bridge** for Awakened PoE Trade


![](https://raw.githubusercontent.com/KloppstockBw/GFNPoEPriceCheck/main/GFNPoEPriceCheck.jpg) 

### Hotkey Usage

| F5 | F6 | F7 | F11 |
|-----|------|--------|----------|
| goto hideout | price check | open steam overlay | force close script |

### Requirements

- GFNPoEPriceCheck.exe

- Awakened POE Trade
  https://github.com/SnosMe/awakened-poe-trade

- Path of exile for **Steam** in Geforce NOW (GGG Version does not work) 

- (Alternatively to the GFNPoEPriceCheck.exe you can run the script GFNPoEPriceCheck.au3 then you need Autoit https://www.autoitscript.com/site/autoit/downloads/ ) 


### Features

- No need to change Awakened PoE Trade settings
- Copy Item Details in background (except in GeForce NOW) 
- config file in documents/mygames/Path Of EXILE containing:
  - URL to google.docs
  - Mouse position to paste item details in GFN
  - Auto start awakened Poe trade if wanted
- more to come - I welcome any ideas

### Install
**Video Guide** will come soon

1. Create a https://docs.google.com/document/create document and share it to everyone so it shows /edit at the end in URL.
2. Change default Website in Steam overlay to the created docs.google.com URL .
3. Set Steam overlay default key to F7
4. Run awakened PoE trade
5. Run GFNPoEPriceCheck
6. Decide in script if you want to autorun awakened on script start (recommended)
7. Show the script where the awakened PoE trade input field is
8. tell the script your docs.google URL
9. Have fun price checking in GeForce NOW

### How it works - short story

- it asks the user for various inputs and safes them to config file
- if the config files contains value it skips the inputs
- in gfn it sends the item details to the steam build in browser where the home page is set to the docs google by the user
- on local PC the scrips reads the docs google site content and copy it to the clipboard
- the scrips renames the gfn window to "Path of exile" so the awakened tool detects it as poe
- finally the scripts copys the data to awakened inside of gfn poe
