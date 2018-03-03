<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<!--
 Nom : MesRecettes2MyCook.xsl
 Role : Conversion d'une base de recettes au format XML issue d'un backup
    du logiciel Android "Mes Recettes"
    https://play.google.com/store/apps/details?id=fr.cookbook&hl=fr
    vers une base de donné XML importable avec le logiciel My-Cook (Mac)
    Description : https://freewares-tutos.blogspot.fr/2010/12/my-cook-un-logiciel-gratuit-pour-gerer.html
    Auteur : Jean-Noël PIOCHE
    Download : http://www.logicielmac.com/download/7d6d2ce1.dl
    Statut : Freeware, non maintenu, sources non disponibles, mais OK sur Mac X.

 Modèle utilisé : /Applications/My-Cook/Fichier Demo.xml

 Auteur : Thierry Maillard
 version : V1.0 - 28/2/2018 - 2/3/2018

 Avec Saxon (parseur XSL-T 2.0) :
 Download : https://sourceforge.net/projects/saxon/files/Saxon-HE/9.8/
 Documentation : http://www.saxonica.com/documentation/
 HOME_SAXON='/Users/thierry/Documents/informatique/developpement/xml/SaxonHE9-4-0-6J'
 java -cp $HOME_SAXON/saxon9he.jar net.sf.saxon.Transform \
    -xsl:MesRecettes2MyCook.xsl \
    -o:recettes_mlaure.xml \
    -s:MyCookBook_Backup_2018-01-26.xml

 For options see : java -cp $HOME_SAXON/saxon9he.jar net.sf.saxon.Transform -?

 Limitation : le parsing des ingrédient n'est pas correct :
    Les ingrédients sont copés tels quels sans unité et sans valeur extraite.

 Copyright 2018 Thierry Maillard
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program.  If not, see [http://www.gnu.org/licenses/]. Contact me at thierry.maillard500n@orange.fr
-->

<!-- Template appliqué à l'ouverture du document -->
<xsl:template match="/cookbook">
    <!-- Ecriture du DOCTYPE -->
    <xsl:text>&#10;</xsl:text>
    <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE CookXML&gt;</xsl:text>
    <xsl:text>&#10;</xsl:text>

    <CookXML version="1.0" lang="fr_FR">
        <xsl:apply-templates select="recipe"/>
        <xsl:call-template name="createFolder"/>
    </CookXML>
</xsl:template>

<!-- Transformation d'une recipe en plat -->
<xsl:template match="recipe">
    <plat>
        <!-- recuperation des attributs du tag plat -->
        <xsl:choose>
            <xsl:when test="category='Entrée'">
                <xsl:attribute name='type'>Entrée</xsl:attribute>
            </xsl:when>
            <xsl:when test="category='Plat'">
                <xsl:attribute name='type'>Plat principal</xsl:attribute>
            </xsl:when>
            <xsl:when test="category='Dessert'">
                <xsl:attribute name='type'>Dessert</xsl:attribute>
            </xsl:when>
            <xsl:when test="category='légume'">
                <xsl:attribute name='type'>Plat principal</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name='type'>Spécial</xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
        <!-- Suppression des blancs en trop et en tete et queue pour le nom du plat -->
        <xsl:attribute name='nom'><xsl:value-of select="normalize-space(title)"/></xsl:attribute>

        <recettes>
            <!-- Une seule version de recette -->
            <recette>
                <xsl:attribute name='version'>1</xsl:attribute>
                <xsl:choose>
                    <xsl:when test="rating &lt; 1">
                        <xsl:attribute name='difficulte'>1</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="rating &gt; 5">
                        <xsl:attribute name='difficulte'>5</xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name='difficulte'>
                            <xsl:value-of select="rating"/>
                        </xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
                <!-- !!! Changer le repertoire de localisation du repertoire contenant les images
                 pour le répertoire contenant les images -->
                <xsl:if test="imagepath != ''">
                    <xsl:attribute name='img'>
                        <xsl:value-of select="replace(imagepath,'/mnt/sdcard/MyCookBook/',
                        '/Users/thierry/Documents/informatique/developpement/xml/MesRecettes2MyCook')"/>
                    </xsl:attribute>
                </xsl:if>

                <temps_preparation>
                    <xsl:call-template name="getTempsAttribute">
                        <xsl:with-param name="valueTagSource">
                            <xsl:value-of select="preptime"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </temps_preparation>


                <temps_cuisson>
                    <xsl:call-template name="getTempsAttribute">
                        <xsl:with-param name="valueTagSource">
                            <xsl:value-of select="cooktime"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </temps_cuisson>

                <ingredients>
                    <xsl:attribute name='nbPersonnes'>
                        <xsl:value-of select="replace(quantity, '(\d+).*', '$1')"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="ingredient"/>
                </ingredients>

                <etapes>
                    <xsl:apply-templates select="recipetext"/>
                </etapes>

                <astuces>
                    <xsl:if test="description != ''">
                        <astuce>
                            <xsl:text>description : </xsl:text>
                            <xsl:value-of select="normalize-space(description)"/>
                        </astuce>
                    </xsl:if>
                    <xsl:if test="comments != ''">
                        <astuce><xsl:value-of select="normalize-space(comments)"/></astuce>
                    </xsl:if>
                    <xsl:if test="source != ''">
                        <astuce>
                            <xsl:text>source : </xsl:text>
                            <xsl:value-of select="normalize-space(source)"/>
                        </astuce>
                    </xsl:if>
                    <xsl:if test="imageurl != ''">
                        <astuce>
                            <xsl:text>imageurl : </xsl:text>
                            <xsl:value-of select="normalize-space(imageurl)"/>
                        </astuce>
                    </xsl:if>
                </astuces>
            </recette>
        </recettes>
    </plat>
</xsl:template>

<!-- Analyse et split des ingredients -->
<xsl:template match="ingredient">
    <!-- Split de la liste des ingredients sur le caractère &#10; = newline  -->
    <xsl:for-each select="tokenize(.,'&#10;')">
        <ingredient>
            <!-- J'abandonne le parsing nom, quantité, unité  -->
            <xsl:attribute name='nom'><xsl:sequence select="replace(., '- ', '')"/></xsl:attribute>
            <xsl:attribute name='quantite'>1</xsl:attribute>
            <xsl:attribute name='unite'>unit.</xsl:attribute>
        </ingredient>
    </xsl:for-each>
</xsl:template>

<!-- Analyse et split des étapes -->
<xsl:template match="recipetext">
    <!-- Elimination du point final qui genererait une étape vide
     '\.$' : expression régulière :
     \. : 
     -->
    <xsl:variable name="etapesWoPoint">
        <xsl:value-of select="replace(., '\.$', '')"/>
    </xsl:variable>

    <!-- Split de la liste des ingredients sur le caractère .
     Ce caractère doit être escapé car sinon il remplace n'importe quel caractère -->
    <xsl:for-each select="tokenize($etapesWoPoint,'\.')">
        <xsl:variable name= "ligneEtape ">
            <xsl:sequence select="normalize-space(.)"/>
        </xsl:variable>
        <xsl:if test="$ligneEtape != ''">
            <etape>
                <xsl:value-of select="$ligneEtape"/>
            </etape>
        </xsl:if>
    </xsl:for-each>
</xsl:template>

<!--
 Fonction : getTempsAttribute
 Role : Retourne les attributs temps et unite en fonction du contenu du parametre valueTagSource
        La valeur peut être vide : dans ce cas temps = 0
 -->
<xsl:template name="getTempsAttribute">
    <xsl:param name="valueTagSource"/>

    <xsl:if test="$valueTagSource = ''">
        <xsl:attribute name='temps'>0</xsl:attribute>
    </xsl:if>
    <xsl:if test="$valueTagSource != ''">
        <xsl:attribute name='temps'>
            <!-- Utilisation d'une expression régulière pour éliminer les unités
             codée de multiples façons dans l'élément lu et ne garder que les chiffres.
             Fonctionnalité XSLT 2.0 -->
            <xsl:value-of select="replace($valueTagSource, '(\d+).*', '$1')"/>
        </xsl:attribute>
    </xsl:if>
    <xsl:attribute name='unite'>min</xsl:attribute>
</xsl:template>

<!--
 Fonction : createFolder
 Role : Regroupe toutes les recettes dans un dossier
 -->
<xsl:template name="createFolder">
    <dossier nom="Recettes de Marie-Laure">
        <xsl:apply-templates select="recipe/title"/>
    </dossier>
</xsl:template>

<!-- Met un élément de recette dans un dossier -->
<xsl:template match="recipe/title">
    <refPlat>
        <xsl:attribute name='nom'>
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:attribute>
        <xsl:attribute name='version'>1</xsl:attribute>
    </refPlat>
</xsl:template>

</xsl:stylesheet>
