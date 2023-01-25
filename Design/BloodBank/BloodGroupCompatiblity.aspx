<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="BloodGroupCompatiblity.aspx.cs" Inherits="Design_BloodBank_BloodGroupCompatiblity" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">


            <b>Blood Group Compatibilty</b>&nbsp;<br />
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
                            <label class="pull-left">From Blood Group</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlFromBloodGroup" title="Select From Blood Group" onchange="BindMappedBloodGroup();"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">To Blood Group</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlToBloodGroup" title="Select To Blood Group"></select>
                        </div>
                        <div class="col-md-8" style="text-align: center">
                            <input type="button" id="btnMap" class="ItdoseButton" value="Map" onclick="MapBloodGroup();" />
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
                    </div>
         <div class="POuter_Box_Inventory">
             <div class="Purchaseheader">Blood Group Compatiblity Mapping</div>
             <div class="row">
                         <div id="divOutPut" style="max-height: 250px; overflow-x: auto;"></div>
             </div>
</div>
    </div>
    <script type="text/javascript">
        $(document).ready(function () {
            LoadBloodGroup();
        });
        function LoadBloodGroup() {
            serverCall('BloodGroupCompatiblity.aspx/LoadBloodGroup', {}, function (response) {
                ddlFromBloodgroup = $('#ddlFromBloodGroup');
                ddlFromBloodgroup.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'BloodGroup', isSearchAble: false });

                ddlToBloodGroup = $('#ddlToBloodGroup');
                ddlToBloodGroup.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'BloodGroup', isSearchAble: false });
            });
        }
        function MapBloodGroup() {
            var FromBG = $('#ddlFromBloodGroup option:selected').html();
            var ToBG = $('#ddlToBloodGroup option:selected').html();
            if ($('#ddlFromBloodGroup option:selected').val() == "0")
            {
                modelAlert('Please Select From Blood Group');
                return false;
            }
            if ($('#ddlToBloodGroup option:selected').val() == "0") {
                modelAlert('Please Select To Blood Group');
                return false;
            }
            serverCall('BloodGroupCompatiblity.aspx/SaveMapBloodGroup', { FromBG: FromBG, ToBG: ToBG }, function (response) {
                var result = parseInt(response);
                if (result == 1) 
                    modelAlert('Blood Group Mapped Successfully');
                else if( result==2)
                    modelAlert('Blood Group Already Mapped');
                else
                    modelAlert('Error Occured');
            });
            BindMappedBloodGroup();
        }
        function BindMappedBloodGroup() {
            var FromBG = $('#ddlFromBloodGroup option:selected').html();
            serverCall('BloodGroupCompatiblity.aspx/BindMappedBloodGroup', { FromBG: FromBG }, function (response) {
                StockData = jQuery.parseJSON(response);
                var output = $('#tb_BloodGroupMapping').parseTemplate(StockData);
                $('#divOutPut').html(output);
                $('#divOutPut').show();
            });
        }
        function DeleteMapping(rowId) {
            var ID = $(rowId).closest('tr').find("#tdID").text();
            serverCall('BloodGroupCompatiblity.aspx/DeleteMapBloodGroup', { ID:ID}, function (response) {
                var result = parseInt(response);
                if (result == 1)
                    modelAlert('Mapping Deleted Successfully');
            });
            BindMappedBloodGroup();
        }
    </script>
    <script id="tb_BloodGroupMapping" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_BloodGroupMappingData" style="width:100%;border-collapse:collapse;">
		<tr id="trHeader">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:200px; display:none">ID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">From Blood Group</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:130px;">To Blood Group</th>
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
                    <td class="GridViewLabItemStyle" style="width:100px;  text-align:center;" ><#=objRow.FromaBG#></td> 
                    <td class="GridViewLabItemStyle" style="width:80px;  text-align:center;" ><#=objRow.ToBG#></td> 
                    <td class="GridViewLabItemStyle" style="width:30px; text-align:center;" ><img id="imgDelete" src="../../Images/Delete.gif" onclick="DeleteMapping(this);" title="Click To Delete Mapping" /></td>
                </tr>           
        <#}#>                     
     </table>    
    </script>
</asp:Content>

