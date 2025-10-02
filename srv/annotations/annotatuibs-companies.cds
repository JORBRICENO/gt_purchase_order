using {PurchaseOrder} from '../service';

annotate PurchaseOrder.VH_Companies with {
    @title : 'Companies'
    ID @Common: {
        Text : Description,
        TextArrangement :  #TextOnly
    }
};
