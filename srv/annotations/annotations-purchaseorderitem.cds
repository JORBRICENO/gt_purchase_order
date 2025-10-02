using {PurchaseOrder} from '../service';

annotate PurchaseOrder.PurchaseOrderItem with {
    PurchaseOrder     @title: 'Purchase Order';
    PurchaseOrderItem @title: 'Purchase Order Item';
    Plant             @title: 'Plant';
    StorageLocation   @title: 'Storage Location';
    Customer          @title: 'Customer';
    Material          @title: 'Material';
    MaterialGroup     @title: 'Matrial Group';
    ProductType       @title: 'Product Type';
    NetPriceQuantity  @title: 'Net Price Quantity';
    NetPriceAmount    @title: 'Net Price Amount';
    OrderPriceUnit    @title: 'Order Quantity';
    DocumentCurrency  @title: 'Currency';
};

annotate PurchaseOrder.PurchaseOrderItem with @(
    UI.LineItem  : [
        {
            $Type : 'UI.DataField',
            Value : PurchaseOrderItem,
            @HTML5.CssDefaults : {
                $Type : 'HTML5.CssDefaultsType',
                width : '12rem'
            }
        },
        {
            $Type : 'UI.DataField',
            Value : Plant
        },
        {
            $Type : 'UI.DataField',
            Value : StorageLocation,
            @HTML5.CssDefaults : {
                $Type : 'HTML5.CssDefaultsType',
                width : '12rem'
            }
        },
        {
            $Type : 'UI.DataField',
            Value : Customer
        },
        {
            $Type : 'UI.DataField',
            Value : Material
        },
        {
            $Type : 'UI.DataField',
            Value : MaterialGroup
        },
        {
            $Type : 'UI.DataField',
            Value : ProductType
        },
        {
            $Type : 'UI.DataField',
            Value : NetPriceQuantity,
            @HTML5.CssDefaults : {
                $Type : 'HTML5.CssDefaultsType',
                width : '8rem'
            }
            
        },
        {
            $Type : 'UI.DataField',
            Value : NetPriceAmount,
            @HTML5.CssDefaults : {
                $Type : 'HTML5.CssDefaultsType',
                width : '8rem'
            }
        },
        {
            $Type : 'UI.DataField',
            Value : OrderPriceUnit,
            @HTML5.CssDefaults : {
                $Type : 'HTML5.CssDefaultsType',
                width : '8rem'
            }
        }
    ]
);
