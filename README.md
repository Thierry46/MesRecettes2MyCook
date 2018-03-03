# MesRecettes2MyCook
A XSLT- 2.0 XML transformation stylesheet  to export a cooking recipies database from Android Software
**Mes recettes** to an import file compatible with the free Mac OS X software **My-Cook** developed by
*Jean-Noël PIOCHE* till 2012.

Usage and more
-----------------
See comments inside MesRecettes2MyCook.xsl for more information (in french sorry)

Related software
-----------------
- `Mes recettes <https://play.google.com/store/apps/details?id=fr.cookbook&hl=fr>`
- `My-Cook download for Mac OS X <http://www.logicielmac.com/download/7d6d2ce1.dl>`
- `My-Cook description <https://freewares-tutos.blogspot.fr/2010/12/my-cook-un-logiciel-gratuit-pour-gerer.html>`

Examples Files provided
-----------------
- MyCookBook_Backup_2018-01-26.xml : a backup recipies file of **Mes recettes** software.
- Fichier Demo.xml : exemple of file iven with **My-Cook** software.
- recettes_mlaure.xml : output file result ready to be imported in  **My-Cook** software.

Pre-Requisites
-----------------
Please install a XSLT 2.0 processor like Saxon for Java
- `Download link for Saxon on Source Forge <https://sourceforge.net/projects/saxon/files/Saxon-HE/9.8/>`
- `Documentation for Saxon <http://www.saxonica.com/documentation/>`

Known limitation
------------
* You have to modify by yourself the absolute name of recipies image directory
* Ingedients are not prsed perfectly : They are copied as is whout splitting their units and values.

Copyright
-----------
    Copyright 2018 Thierry Maillard
    This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
    This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
    You should have received a copy of the GNU General Public License along with this program.  If not, see [http://www.gnu.org/licenses/]. Contact me at thierry.maillard500n@orange.fr
