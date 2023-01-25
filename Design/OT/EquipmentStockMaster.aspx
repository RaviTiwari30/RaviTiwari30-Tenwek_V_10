
<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="EquipmentStockMaster.aspx.cs" Inherits="Design_OT_EquipmentStockMaster" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">


        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>OT Equipment Stock</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError" />&nbsp;              
            </div>
            <div class="POuter_Box_Inventory">
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">
                            Equipment Name
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <select id="ddlEquipment" ></select>
                    </div>
                     <div class="col-md-3">
                        <label class="pull-left">
                           Quantity
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-3">
                        <input type="text" id="txtQty" onlynumber="4" class="requiredField" max-value="9999" value="0" style="width:100px;" />
                    </div>
                     <div class="col-md-3">
                        <input type="button" onclick="saveStock();" value="Save Stock" />
                    </div>
                    <div class="col-md-7">
                        <input type="button" onclick="openCreateAndDeactivePopup();" style="width: 200px;" value="Create & De-Active Equipment" />
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;" runat="server">
                <div class="Purchaseheader">Equipment Stock Details</div>
                <div class="row">
                    <div id="dvEquipmentStockDetails"></div>
                </div>
            </div>
            <asp:Label ClientIDMode="Static" runat="server" ID="lblEquipmentId" Style="display: none"></asp:Label>
            
            <div id="dvCreateAndDeactiveEquipment" class="modal fade">
                <div class="modal-dialog">
                    <div class="modal-content" style="background-color: white; width: 40%;">
                        <div class="modal-header">
                            <button type="button" class="close" onclick="closeCreateAndDeactiveEquipmentModel()" aria-hidden="true">×</button>
                            <h4 class="modal-title"><span id="spnHeaderLabel">Create New Equipment</span> </h4>
                        </div>
                        <div style="max-height: 200px; overflow: auto;" class="modal-body">
                            <div class="row">
                                <div class="col-md-1"></div>
                                <div class="col-md-7">
                                    <label class="pull-left">
                                        Equipment Name 
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-15">
                                    <input type="text" id="txtEquipmentName" class="requiredField" maxlength="100" />
                                </div>
                                <div class="col-md-1"></div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" id="btnSaveEquipment" onclick="onSaveEquipment(1)">Save</button>
                            <button type="button" id="btnDeActiveEquipment" onclick="onDeActiveEquipment()">De-Active</button>
                            <button type="button" onclick="closeCreateAndDeactiveEquipmentModel()">Close</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script type="text/javascript">
            $(document).ready(function () {
                bindEquipment(function () {
                    bindEquipmentStock(function () {});
                });
            });

            var bindEquipment = function (callback) {
                var $ddlEquipment = $('#ddlEquipment');
                serverCall('EquipmentStockMaster.aspx/BindEquipment', {}, function (response) {
                    $ddlEquipment.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'EquipmentName', isSearchAble: true });
                    callback($ddlEquipment.val());

                });
            }

            var bindEquipmentStock = function (callback) {
                serverCall('EquipmentStockMaster.aspx/bindEquipmentStock', {}, function (response) {
                    StockData = JSON.parse(response);
                    var message = $('#tb_EquipmentStock').parseTemplate(StockData);
                    $('#dvEquipmentStockDetails').html(message);
                    callback(true);
                });
            }
            var closeCreateAndDeactiveEquipmentModel = function () {
                $('#dvCreateAndDeactiveEquipment').closeModel();
            }

            var openCreateAndDeactivePopup = function () {

                if ($("#ddlEquipment").val() != "0") {
                    $("#lblEquipmentId").text($("#ddlEquipment").val());
                    $("#btnSaveEquipment").hide();
                    $("#btnDeActiveEquipment").show();
                    $("#txtEquipmentName").val($("#ddlEquipment option:selected").text()).attr('disabled',true);
                    $("#spnHeaderLabel").text("De-Active Selected Equipment");
                }
                else {
                    $("#lblEquipmentId").text("");
                    $("#btnSaveEquipment").show();
                    $("#btnDeActiveEquipment").hide();
                    $("#txtEquipmentName").val("").attr('disabled', false);
                    $("#spnHeaderLabel").text("Create New Equipment");
                }
                $('#dvCreateAndDeactiveEquipment').showModel();
            }

            var onDeActiveEquipment = function () {
                modelConfirmation('Are You Sure ?', 'To De-Active the Selected Equipment', 'Yes', 'No', function (res) {
                    if (res) {
                        onSaveEquipment(2);
                    }
                });
            }

            var onSaveEquipment = function (type) {
                if ($("#txtEquipmentName").val() == "") {
                    $("#txtEquipmentName").focus();
                    return;
                }

                data = {
                    type: type,
                    equipmentId: $("#lblEquipmentId").text(),
                    equipmentName: $("#txtEquipmentName").val()
                }
                serverCall('EquipmentStockMaster.aspx/SaveEquipment', data, function (response) {
                    var responseData = JSON.parse(response);
                    if (responseData.status) {
                        modelAlert(responseData.response, function () {
                            bindEquipment(function () {
                                $('#dvCreateAndDeactiveEquipment').hideModel();
                            });
                        });
                    }
                    else
                        modelAlert(responseData.response);
                });
            }

            var saveStock = function (type) {
                $("#lblMsg").text("");

                if ($("#ddlEquipment").val() == "0") {
                    $("#ddlEquipment").focus();
                    $("#lblMsg").text("Please Select Equipment");
                    return;
                }
                if (Number($("#txtQty").val()) == 0) {
                    $("#txtQty").focus();
                    $("#lblMsg").text("Please Enter Quantity");
                    return;
                }

                data = {
                    equipmentId: Number($("#ddlEquipment").val()),
                    equipmentName: $("#ddlEquipment option:selected").text(),
                    stockQty: Number($("#txtQty").val()),
                }
                serverCall('EquipmentStockMaster.aspx/saveStock', data, function (response) {
                    var responseData = JSON.parse(response);
                    if (responseData.status) {
                        modelAlert(responseData.response, function () {
                            bindEquipmentStock(function () { });
                        });
                    }
                    else
                        modelAlert(responseData.response);
                });
            }

            var validateUpdate = function (ctrlId,CurrentActiveQuantity, ActualActiveQuantity) {
                if (Number(ActualActiveQuantity) == Number(CurrentActiveQuantity)) 
                    $(ctrlId).closest('tr').find('#imgUpdate').hide();
                else
                    $(ctrlId).closest('tr').find('#imgUpdate').show();
            }
            var onUpdateActiveEquipment = function (ctrlId, ID, ActualActiveQuantity) {

                $("#lblMsg").text("");
                var ActiveQty = Number($(ctrlId).closest('tr').find('#txtActiveQty').val());

                if (Number(ActualActiveQuantity) == ActiveQty)
                {
                    $(ctrlId).closest('tr').find('#txtActiveQty').focus();
                    $("#lblMsg").text("Previous Active Quantity and Current Active Quantity should be different for update.");
                    return;
                }
                var Reason = $(ctrlId).closest('tr').find('#txtReason').val();

                if (Reason =="") {
                    $(ctrlId).closest('tr').find('#txtReason').focus();
                    $("#lblMsg").text("Please Enter Reason");
                    return;
                }

                modelConfirmation('Are You Sure ?', 'To Update the Active Quantity', 'Yes', 'No', function (res) {
                    if (res) {
                        data = {
                            activeQty: ActiveQty,
                            equipmentStockID: Number(ID),
                            reason: Reason
                        }
                        serverCall('EquipmentStockMaster.aspx/updateActiveQty', data, function (response) {
                            var responseData = JSON.parse(response);
                            if (responseData.status) {
                                modelAlert(responseData.response, function () {
                                    bindEquipmentStock(function () { });
                                });
                            }
                            else
                                modelAlert(responseData.response);
                        });
                    }
                });
            }

        </script>
        
         <script id="tb_EquipmentStock" type="text/html">
        <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdEquipmentStock" style="width:100%; border-collapse: collapse;">
            <thead>
            <tr id="TrHead">
                <th class="GridViewHeaderStyle" scope="col" >S/No.</th>
                <th class="GridViewHeaderStyle" scope="col" >Equipment Name</th>
                <th class="GridViewHeaderStyle" scope="col" >Stock Date</th>
                <th class="GridViewHeaderStyle" scope="col" >Stock Quantity</th>
                <th class="GridViewHeaderStyle" scope="col" >Active Quantity</th>
                <th class="GridViewHeaderStyle" scope="col" >Update Reason</th>
                <th class="GridViewHeaderStyle" scope="col" >Last Log Reason</th>
                <th class="GridViewHeaderStyle" scope="col" >Update</th>
                <th class="GridViewHeaderStyle" scope="col" style="display:none;" ></th>

                
            </tr>
                </thead><tbody>
        <#       
        var dataLength=StockData.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;
        for(var j=0;j<dataLength;j++)
        {       
        objRow = StockData[j];
        #>
               <tr id="TrBody" >        
                    <td class="GridViewLabItemStyle" style="text-align:center"><#=j+1#></td>
                   <td class="GridViewLabItemStyle" style="text-align:center;width:200px;"><#=objRow.EquipmentName #></td>
                   <td class="GridViewLabItemStyle" style="text-align:center;width:100px;"><#=objRow.StockDate #></td>
                   <td class="GridViewLabItemStyle" style="text-align:center; width:115px;"><#=objRow.StockQuantity #></td>
                   <td class="GridViewLabItemStyle" id="tdActiveQuantity" style="text-align:center ;width:115px;">
                         <input type="text" id="txtActiveQty" onlynumber="4" style="width:100px;" onkeyup="validateUpdate(this,$(this).val(),'<#=objRow.ActiveQuantity #>')" max-value='<#=objRow.StockQuantity #>' value='<#=objRow.ActiveQuantity #>' 
                              onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)" />
                   </td>
                    <td class="GridViewLabItemStyle" style="text-align:center ;width:200px;">
                         <input type="text" id="txtReason" class="requiredField" style="width:200px;" />
                   </td>
                   <td class="GridViewLabItemStyle" style="text-align:left;"><#=objRow.LogReason #></td>
                    <td class="GridViewLabItemStyle" style="text-align:center">
                         <img alt="Update" id="imgUpdate" title="Update" style="display:none;" onclick="onUpdateActiveEquipment(this,'<#=objRow.EquipmentStockID #>','<#=objRow.ActiveQuantity #>')" src="../../Images/edit.png" />
                    </td>
                     <td class="GridViewLabItemStyle" id="tdEquipmentStockID" style="display:none;"><#=objRow.EquipmentStockID#></td>

               </tr>           
        <#}#>   
            </tbody>    
     </table>    
    </script>
</asp:Content>
