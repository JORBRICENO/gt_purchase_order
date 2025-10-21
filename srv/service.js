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
            VHE_Suppliers,
            VHE_Plants,
            VHE_StorageLocation,
            VHE_Product
        } = this.entities;
        
        const api_company = await cds.connect.to("API_COMPANYCODE_SRV");
        const api_org = await cds.connect.to("CE_PURCHASINGORGANIZATION_0001");
        const api_supplier = await cds.connect.to("API_BUSINESS_PARTNER");
        const api_group = await cds.connect.to("CE_PURCHASINGGROUP_0001");
        const api_purchordrtype = await cds.connect.to("ZCE_PURCHASEORDERTYPE");
        const api_plant = await cds.connect.to("API_PLANT_SRV");
        const api_storageloc = await cds.connect.to("API_STORAGELOCATION_SRV");
        const api_product = await cds.connect.to("API_PRODUCT_SRV");
        const api_inforecord = await cds.connect.to("API_INFORECORD_PROCESS_SRV");

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
                    Authorization: 'Basic amJyaWNlbm86TG9nYWxpLjIwMjY='
                }
            })
        });

        this.on('READ', VHE_Plants, async (req) => {
            return await api_plant.tx(req).send({
                query: req.query,
                headers: {
                    apikey: 'MatGW3Mzcozw8FjoqggdaNAzYc7koHho'
                    //Authorization: 'Basic amJyaWNlbm86TG9nYWxpLjIwMjY='
                }
            })
        });

        this.on('READ', VHE_StorageLocation, async (req) => {
            return await api_storageloc.tx(req).send({
                query: req.query,
                headers: {
                    Authorization: 'Basic amJyaWNlbm86TG9nYWxpLjIwMjY='
                }
            })
        });

        this.on('READ', VHE_Product, async (req) => {

            const filter = req.query.SELECT.where;

            let plant = '';
            
            if (filter) {
                plant = filter[2]?.val;
            }

            if (!plant) {
                return [];
            }

            const productQuery = SELECT.from('API_PRODUCT_SRV.A_ProductPlant')
                                .columns('Product')
                                .where({Plant: plant});

            const aResults = await api_product.run(productQuery);
            

            const aIDs = [...new Set(aResults.map( p => p.Product))];

            const chunkSize = 10;
            const promises = [];

            for (let i = 0; i < aIDs.length; i += chunkSize) {
                let chunk = aIDs.slice(i, i + chunkSize);
                
                const productDestailsQuery = SELECT.from('API_PRODUCT_SRV.A_Product')
                                            .columns( p => {
                                                p.Product,
                                                p.to_Description( d => {
                                                    d.ProductDescription
                                                }).where({Language: req.user.locale?? 'EN'})
                                            })
                                            .where({Product: { in: chunk}});

                promises.push(api_product.run(productDestailsQuery));
            }


            const chunkResults = await Promise.all(promises);
            const aProductResults = chunkResults.flat();

            /** Sandbox */

            //     const productDestailsQuery = SELECT.from('API_PRODUCT_SRV.A_Product')
            //                                 .columns( p => {
            //                                     p.Product,
            //                                     p.ProductGroup,
            //                                     p.ProductType,
            //                                     p.BaseUnit,
            //                                     p.to_Description( d => {
            //                                         d.ProductDescription
            //                                     })
            //                                     p.to_ProductProcurement( pp => {
            //                                         pp.PurchaseOrderQuantityUnit
            //                                     })
            //                                     .where({Language: req.user.locale?? 'EN'})
            //                                 })
            //                                 .where({Product: { in: aIDs}});

            // const aProductResults = await api_product.run(productDestailsQuery);

            const results = aProductResults.map( p => ({
                Product : p.Product,
                ProductName: p.to_Description[0].ProductDescription,
                ProductGroup: p.ProductGroup,
                ProductType: p.ProductType,
                PurchaseOrderQuantityUnit: p.to_ProductProcurement?.PurchaseOrderQuantityUnit?? p.BaseUnit,
                Plant : plant
            }));

            return results;

        });

        this.before('PATCH', PurchaseOrderItem.drafts, async (req) => {

            if ('Material_Product' in req.data || 'Plant_Plant' in req.data) {

                const parent = req.params[0].ID;
                const children = req.params[1].ID;
                //PurchaseOrder, Material,Plant,Supplier,PurchasingOrganization

                const result = await SELECT.one.from(PurchaseOrderItem.drafts)
                                    .columns(i => {
                                        i.PurchaseOrder_ID,
                                        i.Material_Product,
                                        i.Plant_Plant,
                                        i.PurchaseOrder (p => {
                                            p.Supplier_Supplier,
                                            p.PurchasingOrganization_PurchasingOrganization
                                        })
                                    })
                                    .where({ID: children, PurchaseOrder_ID: parent});

                let material = result.Material_Product;
                let plant = result.Plant_Plant;
                let supplier = result.PurchaseOrder.Supplier_Supplier;
                let purchasingOrg = result.PurchaseOrder.PurchasingOrganization_PurchasingOrganization;

                if (!material || !plant || !supplier || !purchasingOrg) {
                    console.log("Faltan alguno campos necesarios para poder hacer la consulta");
                }

                const priceQuery = SELECT.one.from('API_INFORECORD_PROCESS_SRV.A_PurgInfoRecdOrgPlantData')
                                    .columns(
                                        'NetPriceAmount',
                                        'Currency',
                                        'MaterialPriceUnitQty',
                                        'NetPriceQuantityUnit',
                                        'PurchaseOrderPriceUnit',
                                        'TaxCode'
                                    ).where({
                                        Material: material,
                                        Plant: plant,
                                        Supplier: supplier,
                                        PurchasingOrganization: purchasingOrg
                                    });

                    try {

                        const priceResult = await api_inforecord.run(priceQuery);

                        console.log(priceResult);
                        
                        if (priceResult) {
                            await UPDATE.entity(PurchaseOrderItem.drafts).set({
                                NetPriceAmount: priceResult.NetPriceAmount,
                                DocumentCurrency_code: priceResult.Currency,
                                NetPriceQuantity: priceResult.MaterialPriceUnitQty,
                                OrderPriceUnit_code: priceResult.PurchaseOrderPriceUnit,
                                PurchaseOrderQuantityUnit_code: priceResult.PurchaseOrderPriceUnit,
                                TaxCode: priceResult.TaxCode
                            })
                            .where({ID: children, PurchaseOrder_ID: parent});
                        } else {
                            await UPDATE.entity(PurchaseOrderItem.drafts).set({
                                NetPriceAmount: '',
                                DocumentCurrency_code: '',
                                NetPriceQuantity: 1,
                                OrderPriceUnit_code: '',
                                PurchaseOrderQuantityUnit_code: '',
                                TaxCode: ''
                            })
                            .where({ID: children, PurchaseOrder_ID: parent});
                        }

                    } catch (error) {
                        console.log(error);
                    }

            } // Cierre if
           
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

            const parentID = req.data.PurchaseOrder_ID;

            let {max} = await SELECT.one.from(PurchaseOrderItem.drafts)
                        .columns('max(PurchaseOrderItem) as max')
                        .where({PurchaseOrder_ID: parentID});

            let newPosition = (parseInt(max ?? 0)) + 10;

            req.data.PurchaseOrderItem = String(newPosition).padStart(5,'0');
        });

        this.after('READ', PurchaseOrder, async (data, req) => {

            const results = Array.isArray(data) ? data : [data];

            if (results.length === 0 || !results[0]) {
                return;
            }

            let totalAmount = false;

            if (req.query.SELECT.columns) {
                totalAmount = req.query.SELECT.columns.some( c => {
                    return c && c.ref && Array.isArray(c.ref) && c.ref.includes('TotalAmount')
                })
            }

            if (!totalAmount) {
                return;
            }

            const itemEntity = req.target.isDraft ? PurchaseOrderItem.drafts : PurchaseOrderItem;

            await Promise.all(results.map(async (header) => {

                if (!header) return;

                let items = header.to_PurchaseOrderItem;

                if (!items) {
                    items = await SELECT.from(itemEntity).where({PurchaseOrder_ID: header.ID})
                }

                if (!items) return;

                const total = items.reduce((sum, item) => {
                    const quantity = item.OrderQuantity || 0;
                    const price = item.NetPriceAmount || 0;
                    return sum + (quantity * price);
                },0);

                header.TotalAmount = total;

            }));

        });

        this.after('PATCH', PurchaseOrderItem.drafts, async (data, req) => {
            const parent = req.params[0].ID;

            if ('OrderQuantity' in req.data || 'NetPriceAmount' in req.data) {
                const allItems = await SELECT.from(PurchaseOrderItem.drafts).where({PurchaseOrder_ID: parent});

                const total = allItems.reduce((sum, item) => {
                    const quantity = item.OrderQuantity || 0;
                    const price = item.NetPriceAmount || 0;
                    return sum + (quantity * price);
                },0);

                await UPDATE.entity(PurchaseOrder.drafts).set({TotalAmount: total}).where({ID: parent});
            }
        });

        return super.init();
    };

};

        //before
        //on
        //after

        //Protocolo HTTP
        //CREATE        --> NEW
        //UPDATE
        //DELETE
        //READ