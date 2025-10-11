const cds = require('@sap/cds');
const moment = require('moment');

module.exports = class PurchaseOrder extends cds.ApplicationService {

   async init () {

        const {
            PurchaseOrder, 
            PurchaseOrderItem, 
            VHE_Companies,
            VHE_Organizations,
            VHE_Groups,
            VHE_PurchaseOrderTypes,
            VHE_Suppliers
        } = this.entities;
        
        const api_company = await cds.connect.to("API_COMPANYCODE_SRV");
        const api_org = await cds.connect.to("CE_PURCHASINGORGANIZATION_0001");
        const api_supplier = await cds.connect.to("API_BUSINESS_PARTNER");
        const api_group = await cds.connect.to("CE_PURCHASINGGROUP_0001");
        const api_purchordrtype = await cds.connect.to("ZCE_PURCHASEORDERTYPE");

        //before
        //on
        //after

        //Protocolo HTTP
        //CREATE        --> NEW
        //UPDATE
        //DELETE
        //READ

        this.on('READ', VHE_Companies, async (req) => {
            return await api_company.tx(req).send({
                query: req.query,
                headers: {
                    apikey: 'MatGW3Mzcozw8FjoqggdaNAzYc7koHho'
                }
            })
        });

        this.on('READ', VHE_Organizations, async (req) => {
            return await api_org.tx(req).send({
                query: req.query,
                headers: {
                    apikey: 'MatGW3Mzcozw8FjoqggdaNAzYc7koHho'
                }
            })
        });

        this.on('READ', VHE_Suppliers, async (req) => {

            const filter = req.query.SELECT.where;
            let purchaseingOrg = '';

            if (filter) {
                purchaseingOrg = filter[2]?.val;
            }

            if (!purchaseingOrg) {
                return [];
            }

            //1010

            const supplierQuery = SELECT.from('API_BUSINESS_PARTNER.A_SupplierPurchasingOrg')
                                .columns('Supplier')
                                .where({PurchasingOrganization:purchaseingOrg});
            const supplierResults = await api_supplier.run(supplierQuery);
            console.log(supplierResults);

            if (supplierResults.length === 0) {
                return [];
            }

            const uniqueSupplierIDs = [...new Set(supplierResults.map(s => s.Supplier))];
            console.log(uniqueSupplierIDs);

            const supplierDetailsQuery = SELECT.from('API_BUSINESS_PARTNER.A_Supplier', supplier => {
                supplier.Supplier,
                supplier.SupplierName
            }).where({Supplier: {in : uniqueSupplierIDs}});

            const aSuppliers = await api_supplier.run(supplierDetailsQuery);

            return aSuppliers.map(supplier => ({
                Supplier : supplier.Supplier,
                SupplierName : supplier.SupplierName,
                PurchasingOrganization : purchaseingOrg
            }));
            
        });

        this.on('READ', VHE_Groups, async (req) => {
            return await api_group.tx(req).send({
                query: req.query,
                headers: {
                    apikey: 'MatGW3Mzcozw8FjoqggdaNAzYc7koHho'
                }
            })
        });

        this.on('READ', VHE_PurchaseOrderTypes, async (req) => {
            return await api_purchordrtype.tx(req).send({
                query: req.query,
                headers: {
                    Authorization: 'Basic amJyaWNlbm86TG9nYWxpLjIwMjU='
                }
            })
        });

        this.before('NEW', PurchaseOrder.drafts, async (req) => {

            const dbp = await SELECT.one.from(PurchaseOrder).columns('max(PurchaseOrder)');
            const dbd = await SELECT.one.from(PurchaseOrder.drafts).columns('max(PurchaseOrder)');
           
            let idbp = parseInt(dbp.max);
            let idbd = parseInt(dbd.max);
            let iNewPurchaseOrder = 0;


            if (isNaN(dbd.max)) {
                iNewPurchaseOrder = idbp + 1;
            } else if (idbd > idbp) {
                iNewPurchaseOrder = idbd + 1;
            } else {
                iNewPurchaseOrder = idbp + 1;
            }

            req.data.PurchaseOrder = String(iNewPurchaseOrder);
            //console.log({moment: moment().format("YYYY/MM/DD")});
            //req.data.PurchaseOrderDate = moment().format("YYYY-MM-DD");
            req.data.PurchaseOrderDate = new Date();
            //https://stackoverflow.com/questions/17855842/moment-js-utc-gives-wrong-date
            req.data.PurchasingProcessingStatus_code = 'A';
        });

        this.before('NEW', PurchaseOrderItem.drafts, async (req) => {
            
        });

        return super.init();
    };

};