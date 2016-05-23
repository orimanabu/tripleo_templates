#!/bin/bash

#ironic node-update fc4a2668-f612-4dfd-a785-e6abf41dfe8e add properties/capabilities='profile:control,boot_option:local'
#ironic node-update 80ef0ca5-2fc6-4719-b8c2-fb32bf9cfe9b add properties/capabilities='profile:control,boot_option:local'
#ironic node-update 654a5d9f-dda8-4b24-ab2e-69e69deb782a add properties/capabilities='profile:control,boot_option:local'
#ironic node-update 5f94b3b6-b124-4e9a-a49b-73259b06b527 add properties/capabilities='profile:compute,boot_option:local'
#ironic node-update a8177190-353a-4725-8146-3ca3b78c14bd add properties/capabilities='profile:compute,boot_option:local'
#ironic node-update b1745510-bea3-4af7-9b48-9d6422e096aa add properties/capabilities='profile:storage,boot_option:local'

ironic node-update b1b19c3a-6cd9-4254-87cf-d0100436b388 replace properties/capabilities='profile:control,node:controller-0,boot_option:local'
ironic node-update cc87b9c6-9b18-4ef8-8c62-3359d774f046 replace properties/capabilities='profile:control,node:controller-1,boot_option:local'
ironic node-update a6dc4897-f859-4f32-8ad5-cd8459897d77 replace properties/capabilities='profile:control,node:controller-2,boot_option:local'
ironic node-update 1fb3375f-6c09-4219-ab41-7458a8d91e2a replace properties/capabilities='profile:compute,node:compute-0,boot_option:local'
ironic node-update 8e7f3350-4b1a-4459-a7fe-73af8ab01efe replace properties/capabilities='profile:compute,node:compute-1,boot_option:local'
ironic node-update 684b672a-7d1f-42cc-ae6b-af2780239210 replace properties/capabilities='profile:ceph-storage,node:storage-0,boot_option:local'
