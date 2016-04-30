# Jelastic GlassFish 4 Cartridge
This cartridge provides [GlassFish 4](https://glassfish.java.net/) on Jelastic Platform.

**GlassFish** is an open source community comprising of users, developers and partners, who are creating an industry leading Java EE compatible enterprise-quality application server. It gives a possibility to develop portable and scalable enterprise applications with a high reliability, performance, and full clustering.

Improvements of the 4th version includes higher productivity, HTML5 support, and implementation of the Java EE 7 specifications, what allows to use all its features.

For more details refer to the [Jelastic documentation](http://docs.jelastic.com/glassfish4).

Follow the [link](http://ops-docs.jelastic.com/private-add-cartridge) in order to find out how to enable the current cartridge at Jelastic dashboard.

### What Jelastic cartridge is?

Jelastic [Platform-as-Infrastructure](http://docs.jelastic.com/what-is-platform-as-infrastructure) supports **OpenShift’s cartridge model** to make it easier for independent software vendors (ISVs) offering core services in multiple platforms and for a wider array of cloud ecosystems and marketplaces. This open standard for technology packaging and deployment enables ISVs and end-users to integrate their own middleware, databases, and services into the platform and make them available to PaaS developers building applications.

A **cartridge** is an advanced packaging format. In our case, it is represented with existing OpenShift cartridge specifications, extended with Jelastic configurations, to provide more complex functionality and the ability to make adjustments in Jelastic. This additional tuning is required based on the difference between the architectures of the two platforms (Jelastic and OpenShift).

Such configuration is quite easy - you just need to fork a basic cartridge and add custom settings. Detailed instruction on how to create your own cartridge can be seen [here](http://ops-docs.jelastic.com/create-cartridge).


### How to add a cartridge to Jelastic Cloud?

Ready cartridge (your own or one of those we’ve already prepared for you) can be added to the Jelastic PaI via JCA. After that it should be tested and published in order to become available through the dashboard. Find out the details in [this](http://ops-docs.jelastic.com/private-add-cartridge) instruction.
