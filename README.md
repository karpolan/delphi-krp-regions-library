# krpRegions library
The **krpRegions library** is a set of components for **Borland Delphi** and **C++Builder** to create cool, unusual, or **skinnable** program user interfaces. This components set is the easiest way to make **skinnable** or **non-rectangular** windows.

It was created by **Anton Karpenko** (better known as [**KARPOLAN**](https://karpolan.com)) in 1998.

This set of components was a **closed-source product**, it was commercially distributed by [**ABF software, Inc.**](https://abf-dev.com) between 2000 and 2020  years.

<p align="center"> 
<img src="https://github.com/karpolan/delphi-krpRegions-library/assets/1213313/69fb7d06-45ee-4a3f-9f24-c92d92ea8791" alt="banner" title="One of advertisement banners to promote krpRegions Library in 20th century :)" />
</p>

In 2024 the author obtained permission from **ABF** to publish all source code of **krpRegions library** as is.

Enjoy :)


## Description
The **krpRegions library** was designed especially for software developers who are bored of standard box-styled windows and want to create cool and unusual application interfaces.

<p align="center"> 
<img src="https://github.com/karpolan/delphi-krpRegions-library/assets/1213313/c443a744-1dfc-4bc9-8ace-2030cd616c6c1" alt="same app different skins" title="Demo of the same app with different skins" />
</p>

The **krpRegions library** is a set of powerful and easy-to-use components for Borland Delphi/C++Builder. This library uses two fundamental technologies: **Skingine**, **Multi-color masks**, and **AREA-BY-COLOR algorithm**. 

<p align="center"> 
<img src="https://github.com/karpolan/delphi-krpRegions-library/assets/1213313/38002443-1edd-4cf6-993e-7e27ebb6663f" alt="Multi-color mask" title="The Multi-Color mask defines the shape and different active areas" />
<img src="https://github.com/karpolan/delphi-krpRegions-library/assets/1213313/b612dc97-7e36-47e0-adb0-c9cb0f7d0923" alt="Skin for Normal state" title="Skin image for Normal state contains full area" />
<img src="https://github.com/karpolan/delphi-krpRegions-library/assets/1213313/6dbc1719-4d10-434e-84bc-8d8e74858eec" alt="Skin for Hover state" title="Skin image for Hover state could be partial to save the application size" />
<img src="https://github.com/karpolan/delphi-krpRegions-library/assets/1213313/5fc88b9f-146a-43be-aeaf-6997a21214d8" alt="Skin for Active state"  title="Skin image for Active state could be partial as well" />
</p>


## Requirements
* Borland Delphi 3 (and  higher) or C++Builder 3 (and higher). 
* OS: Windows 95/98/Me/NT4/2000/XP/7-11


## How to install?
Run the installation program and choose the destination folder. After installation components should appear.

If you don't see new components in the components palette:
1. Run Delphi or C++ Builder.
2. Select *File/Open...* menu item
3. Open *.dpk* or *.bpk* depending of Delphi/C++Builder version (*krpRegions_D4.dpk* means **Delphi 4**, *krpRegions_C3.bpk* - **C++ Builder 3**).
4. Press *Install* button in the Package Editor.
5. Please don't forget to turn off *Stop on Delphi Exception* checkbox in the *Debug options* of Delphi/C++Builder IDE.
6. Make sure that the **destination folder** is present in the Delphi/C++Builder **library search path**.


## History

### December 29, 2024. (Version AS IS):
The source code is published AS IS on GitHub

### September 20, 2005. (Version 2.0):
Some components were redesigned. Added recovery if controls recreate window handle. Delphi 2005 is supported. 

### June 20, 2003. (Version 1.7):
Moved to www.abf-dev.com web site. Some minor changes.

### July 21, 2002. (Version 1.6):
Delphi 7 support. Some new features.

### January 9, 2002. (Version 1.51):
C++Builder 6 support. Some minor changes.

### August 28, 2001. (Version 1.5):
Actions are supported. Non-rectangular region painting added.

### December 12, 2000. (Version 1.4):
Some components have been redesigned. Exceptions are not used for program logic anymore.

### June 6, 2000. (Version 1.3):
C++Builder 5 support. Now distributed by ABF software, Inc. (www.ABFsoftware.com). Fixed bug under Windows NT and Windows 2000 in 15/16 bit (32768/65536 colors) video modes.

### November 26, 1999. (Version 1.1):
Non-English Delphi/C++Builder bugs fixed. The installation program changed. Added *.int files.

### November 7, 1998. (Version 1.0):
First public release.

### September 11, 1998. (Beta Version):
Components for Delphi 3

### April 23, 1998. (Alpha Version):
The "Skinengin" concept and "AREA-BY-COLOR" algorithm
