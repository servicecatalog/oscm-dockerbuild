--
-- Data for Name: revenuesharemodel; Type: TABLE DATA; Schema: bssuser; Owner: bssuser
--

INSERT INTO bssuser.revenuesharemodel (tkey, revenueshare, revenuesharemodeltype, version) VALUES (10000, 5.00, 'OPERATOR_REVENUE_SHARE', 0);
INSERT INTO bssuser.revenuesharemodel (tkey, revenueshare, revenuesharemodeltype, version) VALUES (10001, 0.00, 'BROKER_REVENUE_SHARE', 0);
INSERT INTO bssuser.revenuesharemodel (tkey, revenueshare, revenuesharemodeltype, version) VALUES (10002, 0.00, 'RESELLER_REVENUE_SHARE', 0);
INSERT INTO bssuser.revenuesharemodel (tkey, revenueshare, revenuesharemodeltype, version) VALUES (10003, 0.00, 'MARKETPLACE_REVENUE_SHARE', 0);

--
-- Data for Name: organization; Type: TABLE DATA; Schema: bssuser; Owner: bssuser
--
INSERT INTO bssuser.organization (tkey, address, deregistrationdate, distinguishedname, email, locale, name, organizationid, phone, registrationdate, version, domicilecountry_tkey, url, supportemail, remoteldapactive, cutoffday, operatorpricemodel_tkey, tenant_tkey) VALUES (10000, 'test', NULL, NULL, 'arkadiusz.kowalczyk@ts.fujitsu.com', 'en', 'TechProvider Inc.', '9c4aec44', '123456789', 1509028846535, 1, 84, 'http://example.com', NULL, false, 1, NULL, NULL);
INSERT INTO bssuser.organization (tkey, address, deregistrationdate, distinguishedname, email, locale, name, organizationid, phone, registrationdate, version, domicilecountry_tkey, url, supportemail, remoteldapactive, cutoffday, operatorpricemodel_tkey, tenant_tkey) VALUES (10001, 'address', NULL, NULL, 'arkadiusz.kowalczyk@ts.fujitsu.com', 'en', 'Supplier Inc.', '8acf4870', '123456789', 1509028900018, 1, 139, 'http://example.com', NULL, false, 1, 10000, NULL);

--
-- Data for Name: supportedcurrency; Type: TABLE DATA; Schema: bssuser; Owner: bssuser
--

INSERT INTO bssuser.supportedcurrency (tkey, currencyisocode, version) VALUES (10000, 'EUR', 0);

--
-- Data for Name: usergroup; Type: TABLE DATA; Schema: bssuser; Owner: bssuser
--

INSERT INTO bssuser.usergroup (tkey, version, name, description, isdefault, organization_tkey, referenceid) VALUES (10000, 0, 'default', NULL, true, 10000, NULL);
INSERT INTO bssuser.usergroup (tkey, version, name, description, isdefault, organization_tkey, referenceid) VALUES (10001, 0, 'default', NULL, true, 10001, NULL);

--
-- Data for Name: publiclandingpage; Type: TABLE DATA; Schema: bssuser; Owner: bssuser
--

INSERT INTO bssuser.publiclandingpage (tkey, numberservices, fillincriterion, version) VALUES (10000, 6, 'ACTIVATION_DESCENDING', 0);

--
-- Data for Name: marketplace; Type: TABLE DATA; Schema: bssuser; Owner: bssuser
--

INSERT INTO bssuser.marketplace (tkey, creationdate, version, organization_tkey, marketplaceid, open, taggingenabled, reviewenabled, socialbookmarkenabled, brandingurl, categoriesenabled, publiclandingpage_tkey, pricemodel_tkey, brokerpricemodel_tkey, resellerpricemodel_tkey, trackingcode, enterpriselandingpage_tkey, restricted, tenant_tkey) VALUES (10000, 1509028917126, 0, 10001, '8acf4870', true, true, true, true, NULL, true, 10000, 10003, 10001, 10002, NULL, NULL, false, NULL);

--
-- Data for Name: organizationreference; Type: TABLE DATA; Schema: bssuser; Owner: bssuser
--

INSERT INTO bssuser.organizationreference (tkey, version, targetkey, sourcekey, referencetype) VALUES (10000, 0, 10001, 10001, 'SUPPLIER_TO_CUSTOMER');
INSERT INTO bssuser.organizationreference (tkey, version, targetkey, sourcekey, referencetype) VALUES (10001, 0, 10001, 1, 'PLATFORM_OPERATOR_TO_SUPPLIER');

--
-- Data for Name: localizedresource; Type: TABLE DATA; Schema: bssuser; Owner: bssuser
--

INSERT INTO bssuser.localizedresource (tkey, version, locale, objecttype, objectkey, value) VALUES (10000, 0, 'en', 'ORGANIZATION_DESCRIPTION', 10000, '');
INSERT INTO bssuser.localizedresource (tkey, version, locale, objecttype, objectkey, value) VALUES (10001, 0, 'en', 'ORGANIZATION_DESCRIPTION', 10001, '');
INSERT INTO bssuser.localizedresource (tkey, version, locale, objecttype, objectkey, value) VALUES (10002, 0, 'en', 'MARKETPLACE_NAME', 10000, 'SuperMarkt');

--
-- Data for Name: marketplacehistory; Type: TABLE DATA; Schema: bssuser; Owner: bssuser
--

INSERT INTO bssuser.marketplacehistory (tkey, creationdate, moddate, modtype, moduser, objkey, objversion, organizationobjkey, invocationdate, marketplaceid, open, taggingenabled, reviewenabled, socialbookmarkenabled, brandingurl, categoriesenabled, pricemodelobjkey, brokerpricemodelobjkey, resellerpricemodelobjkey, trackingcode, restricted) VALUES (10000, 1509028917126, '2017-10-26 14:41:57.247', 'ADD', '1000', 10000, 0, 10001, '2017-10-26 14:41:57.247', '8acf4870', true, true, true, true, NULL, true, 10003, 10001, 10002, NULL, false);

--
-- Data for Name: marketplacetoorganization; Type: TABLE DATA; Schema: bssuser; Owner: bssuser
--

INSERT INTO bssuser.marketplacetoorganization (tkey, version, marketplace_tkey, organization_tkey, publishingaccess) VALUES (10000, 0, 10000, 10001, 'PUBLISHING_ACCESS_GRANTED');

--
-- Data for Name: platformuser; Type: TABLE DATA; Schema: bssuser; Owner: bssuser
--

INSERT INTO bssuser.platformuser (tkey, additionalname, address, creationdate, email, failedlogincounter, firstname, lastname, locale, phone, salutation, status, passwordsalt, passwordhash, userid, version, organizationkey, useridcnt, olduserid, realmuserid, passwordrecoverystartdate) VALUES (10000, NULL, NULL, 1509028847028, 'arkadiusz.kowalczyk@ts.fujitsu.com', 0, '', '', 'en', NULL, NULL, 'PASSWORD_MUST_BE_CHANGED', -2540033260347373361, '\xf76c9a637a5f79bc1b777dfae15b551c53091c814c0f6b232d45eb981ada265e', 'tech_provider', 0, 10000, NULL, NULL, 'tech_provider', 0);
INSERT INTO bssuser.platformuser (tkey, additionalname, address, creationdate, email, failedlogincounter, firstname, lastname, locale, phone, salutation, status, passwordsalt, passwordhash, userid, version, organizationkey, useridcnt, olduserid, realmuserid, passwordrecoverystartdate) VALUES (10001, NULL, NULL, 1509028900225, 'arkadiusz.kowalczyk@ts.fujitsu.com', 0, '', '', 'en', NULL, NULL, 'PASSWORD_MUST_BE_CHANGED', -8360201230380611968, '\x835d6129f3fa5a867935f9b105d90ddff4eeafa75897d5566e8e401522fc235a', 'supplier', 0, 10001, NULL, NULL, 'supplier', 0);


--
-- Data for Name: paymentinfo; Type: TABLE DATA; Schema: bssuser; Owner: bssuser
--

INSERT INTO bssuser.paymentinfo (tkey, creationtime, externalidentifier, version, paymenttype_tkey, paymentinfoid, organization_tkey, providername, accountnumber) VALUES (10000, 1509028846535, NULL, 0, 3, 'Invoice', 10000, NULL, NULL);
INSERT INTO bssuser.paymentinfo (tkey, creationtime, externalidentifier, version, paymenttype_tkey, paymentinfoid, organization_tkey, providername, accountnumber) VALUES (10001, 1509028900018, NULL, 0, 3, 'Invoice', 10001, NULL, NULL);

--
-- Data for Name: organizationhistory; Type: TABLE DATA; Schema: bssuser; Owner: bssuser
--

INSERT INTO bssuser.organizationhistory (tkey, address, deregistrationdate, distinguishedname, email, locale, name, organizationid, phone, registrationdate, moddate, modtype, moduser, objkey, objversion, invocationdate, domicilecountryobjkey, url, supportemail, remoteldapactive, cutoffday, operatorpricemodelobjkey) VALUES (10000, 'test', NULL, NULL, 'arkadiusz.kowalczyk@ts.fujitsu.com', 'en', 'TechProvider Inc.', '9c4aec44', '123456789', 1509028846535, '2017-10-26 14:40:46.535', 'ADD', '1000', 10000, 0, '2017-10-26 14:40:46.535', NULL, 'http://example.com', NULL, false, 1, NULL);
INSERT INTO bssuser.organizationhistory (tkey, address, deregistrationdate, distinguishedname, email, locale, name, organizationid, phone, registrationdate, moddate, modtype, moduser, objkey, objversion, invocationdate, domicilecountryobjkey, url, supportemail, remoteldapactive, cutoffday, operatorpricemodelobjkey) VALUES (10001, 'test', NULL, NULL, 'arkadiusz.kowalczyk@ts.fujitsu.com', 'en', 'TechProvider Inc.', '9c4aec44', '123456789', 1509028846535, '2017-10-26 14:40:47.028', 'MODIFY', '1000', 10000, 1, '2017-10-26 14:40:47.028', 84, 'http://example.com', NULL, false, 1, NULL);
INSERT INTO bssuser.organizationhistory (tkey, address, deregistrationdate, distinguishedname, email, locale, name, organizationid, phone, registrationdate, moddate, modtype, moduser, objkey, objversion, invocationdate, domicilecountryobjkey, url, supportemail, remoteldapactive, cutoffday, operatorpricemodelobjkey) VALUES (10002, 'address', NULL, NULL, 'arkadiusz.kowalczyk@ts.fujitsu.com', 'en', 'Supplier Inc.', '8acf4870', '123456789', 1509028900018, '2017-10-26 14:41:40.018', 'ADD', '1000', 10001, 0, '2017-10-26 14:41:40.018', NULL, 'http://example.com', NULL, false, 1, 10000);
INSERT INTO bssuser.organizationhistory (tkey, address, deregistrationdate, distinguishedname, email, locale, name, organizationid, phone, registrationdate, moddate, modtype, moduser, objkey, objversion, invocationdate, domicilecountryobjkey, url, supportemail, remoteldapactive, cutoffday, operatorpricemodelobjkey) VALUES (10003, 'address', NULL, NULL, 'arkadiusz.kowalczyk@ts.fujitsu.com', 'en', 'Supplier Inc.', '8acf4870', '123456789', 1509028900018, '2017-10-26 14:41:40.225', 'MODIFY', '1000', 10001, 1, '2017-10-26 14:41:40.225', 139, 'http://example.com', NULL, false, 1, 10000);


--
-- Data for Name: organizationreferencehistory; Type: TABLE DATA; Schema: bssuser; Owner: bssuser
--

INSERT INTO bssuser.organizationreferencehistory (tkey, moddate, modtype, moduser, objkey, objversion, targetobjkey, sourceobjkey, invocationdate, referencetype) VALUES (10000, '2017-10-26 14:41:40.225', 'ADD', '1000', 10000, 0, 10001, 10001, '2017-10-26 14:41:40.225', 'SUPPLIER_TO_CUSTOMER');
INSERT INTO bssuser.organizationreferencehistory (tkey, moddate, modtype, moduser, objkey, objversion, targetobjkey, sourceobjkey, invocationdate, referencetype) VALUES (10001, '2017-10-26 14:41:40.225', 'ADD', '1000', 10001, 0, 10001, 1, '2017-10-26 14:41:40.225', 'PLATFORM_OPERATOR_TO_SUPPLIER');

--
-- Data for Name: organizationreftopaymenttype; Type: TABLE DATA; Schema: bssuser; Owner: bssuser
--

INSERT INTO bssuser.organizationreftopaymenttype (tkey, usedasdefault, version, organizationreference_tkey, organizationrole_tkey, paymenttype_tkey, usedasservicedefault) VALUES (10000, false, 0, 10001, 1, 3, false);

--
-- Data for Name: organizationtorole; Type: TABLE DATA; Schema: bssuser; Owner: bssuser
--

INSERT INTO bssuser.organizationtorole (tkey, version, organization_tkey, organizationrole_tkey) VALUES (10000, 0, 10000, 2);
INSERT INTO bssuser.organizationtorole (tkey, version, organization_tkey, organizationrole_tkey) VALUES (10001, 0, 10000, 3);
INSERT INTO bssuser.organizationtorole (tkey, version, organization_tkey, organizationrole_tkey) VALUES (10002, 0, 10001, 1);
INSERT INTO bssuser.organizationtorole (tkey, version, organization_tkey, organizationrole_tkey) VALUES (10003, 0, 10001, 3);
INSERT INTO bssuser.organizationtorole (tkey, version, organization_tkey, organizationrole_tkey) VALUES (10004, 0, 10001, 5);

--
-- Data for Name: organizationtorolehistory; Type: TABLE DATA; Schema: bssuser; Owner: bssuser
--

INSERT INTO bssuser.organizationtorolehistory (tkey, moddate, modtype, moduser, objkey, objversion, organizationroletkey, organizationtkey, invocationdate) VALUES (10000, '2017-10-26 14:40:47.028', 'ADD', '1000', 10000, 0, 2, 10000, '2017-10-26 14:40:47.028');
INSERT INTO bssuser.organizationtorolehistory (tkey, moddate, modtype, moduser, objkey, objversion, organizationroletkey, organizationtkey, invocationdate) VALUES (10001, '2017-10-26 14:40:47.028', 'ADD', '1000', 10001, 0, 3, 10000, '2017-10-26 14:40:47.028');
INSERT INTO bssuser.organizationtorolehistory (tkey, moddate, modtype, moduser, objkey, objversion, organizationroletkey, organizationtkey, invocationdate) VALUES (10002, '2017-10-26 14:41:40.225', 'ADD', '1000', 10002, 0, 1, 10001, '2017-10-26 14:41:40.225');
INSERT INTO bssuser.organizationtorolehistory (tkey, moddate, modtype, moduser, objkey, objversion, organizationroletkey, organizationtkey, invocationdate) VALUES (10003, '2017-10-26 14:41:40.225', 'ADD', '1000', 10003, 0, 3, 10001, '2017-10-26 14:41:40.225');

--
-- Data for Name: paymentinfohistory; Type: TABLE DATA; Schema: bssuser; Owner: bssuser
--

INSERT INTO bssuser.paymentinfohistory (tkey, creationtime, externalidentifier, moddate, modtype, moduser, objkey, objversion, paymenttypeobjkey, invocationdate, paymentinfoid, organizationobjkey, providername, accountnumber) VALUES (10000, 1509028846535, NULL, '2017-10-26 14:40:47.028', 'ADD', '1000', 10000, 0, 3, '2017-10-26 14:40:47.028', 'Invoice', 10000, NULL, NULL);
INSERT INTO bssuser.paymentinfohistory (tkey, creationtime, externalidentifier, moddate, modtype, moduser, objkey, objversion, paymenttypeobjkey, invocationdate, paymentinfoid, organizationobjkey, providername, accountnumber) VALUES (10001, 1509028900018, NULL, '2017-10-26 14:41:40.225', 'ADD', '1000', 10001, 0, 3, '2017-10-26 14:41:40.225', 'Invoice', 10001, NULL, NULL);

--
-- Data for Name: platformuserhistory; Type: TABLE DATA; Schema: bssuser; Owner: bssuser
--

INSERT INTO bssuser.platformuserhistory (tkey, additionalname, address, creationdate, email, failedlogincounter, firstname, lastname, locale, phone, salutation, status, passwordsalt, passwordhash, userid, moddate, modtype, moduser, objkey, objversion, organizationobjkey, invocationdate, realmuserid, passwordrecoverystartdate) VALUES (10000, NULL, NULL, 1509028847028, 'arkadiusz.kowalczyk@ts.fujitsu.com', 0, '', '', 'en', NULL, NULL, 'PASSWORD_MUST_BE_CHANGED', -2540033260347373361, '\xf76c9a637a5f79bc1b777dfae15b551c53091c814c0f6b232d45eb981ada265e', 'tech_provider', '2017-10-26 14:40:47.028', 'ADD', '1000', 10000, 0, 10000, '2017-10-26 14:40:47.028', 'tech_provider', 0);

--
-- Data for Name: revenuesharemodelhistory; Type: TABLE DATA; Schema: bssuser; Owner: bssuser
--

INSERT INTO bssuser.revenuesharemodelhistory (tkey, moddate, modtype, moduser, objkey, objversion, revenueshare, revenuesharemodeltype, invocationdate) VALUES (10000, '2017-10-26 14:41:40.018', 'ADD', '1000', 10000, 0, 5.00, 'OPERATOR_REVENUE_SHARE', '2017-10-26 14:41:40.018');
INSERT INTO bssuser.revenuesharemodelhistory (tkey, moddate, modtype, moduser, objkey, objversion, revenueshare, revenuesharemodeltype, invocationdate) VALUES (10001, '2017-10-26 14:41:57.247', 'ADD', '1000', 10001, 0, 0.00, 'BROKER_REVENUE_SHARE', '2017-10-26 14:41:57.247');
INSERT INTO bssuser.revenuesharemodelhistory (tkey, moddate, modtype, moduser, objkey, objversion, revenueshare, revenuesharemodeltype, invocationdate) VALUES (10002, '2017-10-26 14:41:57.247', 'ADD', '1000', 10002, 0, 0.00, 'RESELLER_REVENUE_SHARE', '2017-10-26 14:41:57.247');
INSERT INTO bssuser.revenuesharemodelhistory (tkey, moddate, modtype, moduser, objkey, objversion, revenueshare, revenuesharemodeltype, invocationdate) VALUES (10003, '2017-10-26 14:41:57.247', 'ADD', '1000', 10003, 0, 0.00, 'MARKETPLACE_REVENUE_SHARE', '2017-10-26 14:41:57.247');


--
-- Data for Name: roleassignment; Type: TABLE DATA; Schema: bssuser; Owner: bssuser
--

INSERT INTO bssuser.roleassignment (tkey, version, user_tkey, userrole_tkey) VALUES (10000, 0, 10000, 3);
INSERT INTO bssuser.roleassignment (tkey, version, user_tkey, userrole_tkey) VALUES (10001, 0, 10000, 1);
INSERT INTO bssuser.roleassignment (tkey, version, user_tkey, userrole_tkey) VALUES (10002, 0, 10001, 2);
INSERT INTO bssuser.roleassignment (tkey, version, user_tkey, userrole_tkey) VALUES (10003, 0, 10001, 1);
INSERT INTO bssuser.roleassignment (tkey, version, user_tkey, userrole_tkey) VALUES (10004, 0, 10001, 5);

--
-- Data for Name: usergrouphistory; Type: TABLE DATA; Schema: bssuser; Owner: bssuser
--

INSERT INTO bssuser.usergrouphistory (tkey, name, description, isdefault, invocationdate, moddate, modtype, moduser, objkey, objversion, organizationobjkey, referenceid) VALUES (10000, 'default', NULL, true, '2017-10-26 14:40:47.028', '2017-10-26 14:40:47.028', 'ADD', '1000', 10000, 0, 10000, NULL);
INSERT INTO bssuser.usergrouphistory (tkey, name, description, isdefault, invocationdate, moddate, modtype, moduser, objkey, objversion, organizationobjkey, referenceid) VALUES (10001, 'default', NULL, true, '2017-10-26 14:41:40.225', '2017-10-26 14:41:40.225', 'ADD', '1000', 10001, 0, 10001, NULL);



