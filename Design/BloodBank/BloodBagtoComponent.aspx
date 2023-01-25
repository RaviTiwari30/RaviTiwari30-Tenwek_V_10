<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="BloodBagtoComponent.aspx.cs" Inherits="Design_BloodBank_BloodBagtoComponent" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">


            <b>Blood Bag to Blood Component Mapping</b>&nbsp;<br />
            <span id="spnErrorMsg" class="ItDoseLblError"></span>
            <div style="text-align: center">
            </div>

        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Blood Bag Type</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlBloodBag" title="Select From Blood Bag" onchange="BindMappedBloodBagType();"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">To Component</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlBloodComponent" title="Select To Blood Component"></select>
                        </div>
                        <div class="col-md-8" style="text-align: center">
                            <input type="button" id="btnMap" class="ItdoseButton" value="Map" onclick="MapBloodBag();" />
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
                    </div>
         <div class="POuter_Box_Inventory">
             <div class="Purchaseheader">Blood Bag to Blood Component Mapping</div>
             <div class="row">
                         <div id="divOutPut" style="max-height: 250px; overflow-x: auto;"></div>
             </div>
</div>
    </div>
    <script type="text/javascript">
        $(document).ready(function () {
            LoadBloodBag();
            LoadBloodComponent();
        });
        function LoadBloodBag() {
            serverCall('BloodBagtoComponent.aspx/LoadBloodBag', {}, function (response) {
                ddlBloodBag = $('#ddlBloodBag');
                ddlBloodBag.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'BagType', isSearchAble: false });
            });
        }
        function LoadBloodComponent() {
            serverCall('BloodBagtoComponent.aspx/LoadBloodComponent', {}, function (response) {
                ddlBloodComponent = $('#ddlBloodComponent');
                ddlBloodComponent.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'ComponentName', isSearchAble: false });
            });
        }
        function MapBloodBag() {
            var BloodBagID = $('#ddlBloodBag option:selected').val();
            var BloodBagName = $('#ddlBloodBag option:selected').text();
            var ComponentID = $('#ddlBloodComponent option:selected').val();
            var ComponentName = $('#ddlBloodComponent option:selected').text();
            if (BloodBagID == "0")
            {
                modelAlert('Please Select From Blood Bag Type');
                return false;
            }
            if (ComponentID == "0") {
                modelAlert('Please Select To Blood Component');
                return false;
            }
            serverCall('BloodBagtoComponent.aspx/SaveMapBloodBagType', { BloodBagID: BloodBagID, BloodBagName: BloodBagName, ComponentID: ComponentID, ComponentName: ComponentName }, function (response) {
                var result = parseInt(response);
                if (result == 1) 
                    modelAlert('Blood Bag Type Mapped Successfully', function () {
                        BindMappedBloodBagType();
                    });
                else if( result==2)
                    modelAlert('Mapping Already Mapped');
                else
                    modelAlert('Error Occured');
            });
        }
        function BindMappedBloodBagType() {
            var BagTypeID = $('#ddlBloodBag option:selected').val();
            serverCall('BloodBagtoComponent.aspx/BindMappedBloodBag', { BagTypeID: BagTypeID }, function (response) {
                StockData = jQuery.parseJSON(response);
                var output = $('#tb_BloodBagMapping').parseTemplate(StockData);
                $('#divOutPut').html(output);
                $('#divOutPut').show();
            });
        }
        function DeleteMapping(rowId) {
            var ID = $(rowId).closest('tr').find("#tdID").text();
            serverCall('BloodBagtoComponent.aspx/DeleteMapBloodBag', { ID: ID }, function (response) {
                var result = parseInt(response);
                if (result == 1)
                    modelAlert('Mapping Deleted Successfully', function () {
                        BindMappedBloodBagType();
                    });
            });
        }
    </script>
    <script id="tb_BloodBagMapping" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_BloodBagMappingData" style="width:100%;border-collapse:collapse;">
		<tr id="trHeader">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:200px; display:none">ID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Blood Bag Type Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:130px;">Blood Commponent Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Delete</th>
		</tr>
        <#       
        var dataLength=StockData.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;     
        for(var j=0;j<dataLength;j++)
        {       
        objRow = StockData[j];
        #>
                <tr id="tr1">                            
                    <td class="GridViewLabItemStyle" style="width:30px;  text-align:center;"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="tdID" style="width:200px; display:none" ><#=objRow.ID#></td> 
                    <td class="GridViewLabItemStyle" id="tdBagTypeID" style="width:200px; display:none" ><#=objRow.BagTypeID#></td> 
                    <td class="GridViewLabItemStyle" id="tdBagTypeName" style="width:200px; display:none" ><#=objRow.ComponentID#></td> 
                    <td class="GridViewLabItemStyle" style="width:100px;  text-align:center;" ><#=objRow.BagTypeName#></td> 
                    <td class="GridViewLabItemStyle" style="width:80px;  text-align:center;" ><#=objRow.ComponentName#></td> 
                    <td class="GridViewLabItemStyle" style="width:30px; text-align:center;" ><img id="imgDelete" src="../../Images/Delete.gif" onclick="DeleteMapping(this);" title="Click To Delete Mapping" /></td>
                </tr>           
        <#}#>                     
     </table>    
    </script>
</asp:Content>

