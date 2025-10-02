using {PurchaseOrder} from '../service';

annotate PurchaseOrder.VH_Suppliers with {
    @title : 'Suppliers'
    ID @Common: {
        Text : SupplierName,
        TextArrangement : #TextOnly
    }
};
