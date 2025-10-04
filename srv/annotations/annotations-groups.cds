using {PurchaseOrder} from '../service';


annotate PurchaseOrder.VH_Groups with {
    @title : 'Groups'
    ID @Common: {
        Text : PurchasingGroup,
        TextArrangement : #TextOnly
    };
    PurchasingGroup @title : 'Group'
};
