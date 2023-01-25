<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="BloodBagTypeMaster.aspx.cs" Inherits="Design_BloodBank_BloodBagTypeMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">


            <b>Blood Bag Type Master</b>&nbsp;<br />
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
                            <label class="pull-left">Bag Type Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtBagTypeName" placeholder="Enter BagType Name" />
                        </div>
                        <div class="col-md-3">
                            <input type="button" id="btnSave" onclick="SaveBagType();" value="Save" />
                        </div>
                        <div class="col-md-5">
                        </div>
                        <div class="col-md-8" style="text-align: center">
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
         <div class="POuter_Box_Inventory">
              <div class="Purchaseheader">Search Blood Bag Type </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div id="divOutPut" style="max-height: 250px; overflow-x: auto;"></div>
                    </div>
                    </div>
                <div class="col-md-1"></div>
                </div>
             </div>
    </div>
    <script type="text/javascript">
        $(document).ready(function () {
            LoadBagType();
        });
        var SaveBagType = function () {
            var BagTypeName = $('#txtBagTypeName').val().trim();
            serverCall('BloodBagTypeMaster.aspx/SaveBagType', { BagTypeName: BagTypeName }, function (response) {
                var result = JSON.parse(response);
                if (result.status) {
                    modelAlert(result.response, function () {
                        LoadBagType();
                    });
                }
                else
                    modelAlert(result.response, function () { });
                $('#txtBagTypeName').val('');
            });
        }
        var LoadBagType = function () {
            serverCall('BloodBagTypeMaster.aspx/LoadBagType', {}, function (response) {
                ResultData = jQuery.parseJSON(response);
                var output = $('#tb_BloodBag').parseTemplate(ResultData);
                $('#divOutPut').html(output);
                $('#divOutPut').show();
            });
        }
        var UpdateBagType = function (rowID) {
            var ID = $(rowID).closest('tr').find("#tdID").text();
            var BagTypeName = $(rowID).closest('tr').find("#txtBagTypeUpdate").val();
            var ActiveStatus = "";
            if ($(rowID).closest('tr').find("#rdotdActive").is(':checked'))
                ActiveStatus = 1;
            else if ($(rowID).closest('tr').find("#rdotdDeActive").is(':checked'))
                ActiveStatus = 0;

            serverCall('BloodBagTypeMaster.aspx/UpdateBagType', { BagTypeName: BagTypeName, ID: ID, ActiveStatus: ActiveStatus }, function (response) {
                var result = JSON.parse(response);
                if (result.status) {
                    modelAlert(result.response, function () {
                        LoadBagType();
                    });
                }
                else
                    modelAlert(result.response, function () { });
                $('#txtBagTypeName').val('');
            });
           
        }
    </script>
      <script id="tb_BloodBag" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_BloodBagData" style="width:100%;border-collapse:collapse;">
		<tr id="trHeader">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:200px; display:none">ID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Bag Type Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:130px;">Status</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Select</th>
		</tr>
        <#       
        var dataLength=ResultData.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;     
        for(var j=0;j<dataLength;j++)
        {       
        objRow = ResultData[j];
        #>
                <tr id="tr1">                            
                    <td class="GridViewLabItemStyle" style="width:30px;  text-align:center;"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="tdID" style="width:200px; display:none" ><#=objRow.ID#></td> 
                    <td class="GridViewLabItemStyle" style="width:100px;  text-align:center;" >
                        <input type="text" id="txtBagTypeUpdate" value='<#=objRow.BagType#>' />
                    </td> 
                    <td class="GridViewLabItemStyle" style="width:80px;  text-align:center;" >
                         <input type="radio" id="rdotdActive" name="tdActive_<#=j+1#>" value="1"   <#if(objRow.IsActive=="1"){#> checked="checked"  <#} #> />Yes                         
						 <input type="radio" id="rdotdDeActive" name="tdActive_<#=j+1#>" value="0" <#if(objRow.IsActive=="0"){#> checked="checked"  <#} #>  />No    

                    </td> 
                    <td class="GridViewLabItemStyle" style="width:30px; text-align:center;" ><img id="imgSelect" src="../../Images/Post.gif" onclick="UpdateBagType(this);" title="Click To Update Bag Type" /></td>
                </tr>           
        <#}#>                     
     </table>    
    </script>
</asp:Content>

