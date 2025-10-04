const cds = require('@sap/cds');
const moment = require('moment');

module.exports = class PurchaseOrder extends cds.ApplicationService {

   async init () {

        const {PurchaseOrder, PurchaseOrderItem, VHE_Companies} = this.entities;
        const api_company = await cds.connect.to("API_COMPANYCODE_SRV");

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