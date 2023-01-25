<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="ReciveAsSet.aspx.cs" Inherits="Design_CSSD_ReciveAsSet" Title="Untitled Page"
    EnableEventValidation="false" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral,
 PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        $(function () {
            Items();
        });
        function Items() {
            $("#ddlSetItem option").remove();
            var ddlBatch = $("#ddlSetItem");

            serverCall('Services/SetItems.asmx/ReciveAsSet', {}, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.length == 0) {
                    ddlBatch.append($("<option></option>").val("0").html("---No Data Found---"));
                }
                else {
                    ddlBatch.bindDropDown({ defaultValue: 'Select', data: responseData, valueField: 'SetID', textField: 'NAME', isSearchAble: true });
                }


            });

        }
        var PatientData = "";
        $(document).ready(

                      function () {
                          $("#btnSave").hide();
                          $("#btnAdd").click(AddItem);
                          $("#btnSave").click(SaveData);
                          $("#ddlSetItem").change(AddItem);
                      }
                     );
        function SaveData() {
            $("#btnSave").attr('disabled', true);
            var Itemdata = "";
            $("#tb_grdLabSearch").find("#txtRecievedQty").each(function () {
                $row = $(this).closest('table').closest('tr');
                var SetQuantity = $row.find('#tdSetQuantity').text();
                var ReceiveQty = $row.find('#tdReceiveQty').text();
                var ReceivedQty = $(this).val();
                if (eval(eval(ReceiveQty) + eval(ReceivedQty)) > eval(SetQuantity)) {
                    DisplayMsg('MM249', 'lblmsg');
                    return;
                }
            });
            var dataSet = new Array();
            var ObjReSet = new Object();
            $("#tb_grdLabSearch").find("#txtRecievedQty").each(function () {
                $row = $(this).closest('table').closest('tr');

                if ($(this).val() != 0) {
                    ObjReSet.SetID = $row.find('#SetID').text();
                    ObjReSet.SetName = encodeURIComponent($row.find('#SetName').text());
                    ObjReSet.ItemID = $row.find('#ItemID').text();
                    ObjReSet.ItemName = encodeURIComponent($row.find('#ItemName').text().split('#')[0]);
                    ObjReSet.SetQuantity = $row.find('#tdSetQuantity').text();
                    ObjReSet.StockID = $(this).closest('tr').attr('id');
                    ObjReSet.ReceivedQty = $(this).val();
                    dataSet.push(ObjReSet);
                    ObjReSet = new Object();
                }
            });
            if (dataSet.length == "0") {
                DisplayMsg('MM249', 'lblmsg');
                $("#btnSave").attr('disabled', false);
                return;
            }

            serverCall('Services/SetItems.asmx/RecieveSet', { ItemData: dataSet, SetStockID: $("#lblSetStockID").text() }, function (response) {

                if (response == "1") {
                    $("#tb_grdLabSearch tr:not(:first)").remove();
                    $("#tb_grdLabSearch").hide();
                    modelAlert('Record Saved Successfully', function () {
                        location.reload();

                    });
                    //$("#btnSave").hide();
                    //$("#ddlSetItem").get(0).selectedIndex = 0;
                    //$("#btnSave").attr('disabled', false);
                }
                else {
                    DisplayMsg('MM07', 'lblmsg');
                    $("#btnSave").show();
                    $("#btnSave").attr('disabled', false);
                }

            });



        }
        var PatientData = "";
        function AddItem() {
            $("#lblmsg").text('');
            var ItemData = $("#ddlSetItem option:selected").val();
            if ($("#ddlSetItem  option:selected").text().toUpperCase() == "SELECT") {
                $("#tb_grdLabSearch").hide();
                $("#btnSave").hide();
                return;
            }


            getSetStockId(ItemData, function (setStockId) {
                serverCall('Services/SetItems.asmx/LoadSetItemsWithStock', { SetID: ItemData, SetStockID: setStockId }, function (response) {
                    PatientData = JSON.parse(response);
                    if (PatientData != '') {
                        var output = $('#tb_PatientLabSearch').parseTemplate(PatientData);
                        $('#PatientLabSearchOutput').html(output);
                        $('#PatientLabSearchOutput').show();
                        $("#btnSave").show();
                        var set = 1;
                        $("#tb_grdLabSearch").find("#txtRecievedQty").each(function () {
                            $row = $(this).closest('table').closest('tr');
                            var SetQuantity = $row.find('#tdSetQuantity').text();
                            var ReceiveQty = $row.find('#tdReceiveQty').text();
                            $("#btnSave").attr('disabled', true);
                            var ToBeReceiveQty = SetQuantity - ReceiveQty;
                            $row.find('#txtRecieveNew').focus().val($row.find('#txtRecieveNew').val());
                            if (eval($row.find('#tdSetQuantity').text()) != eval($row.find('#tdReceiveQty').text())) {
                                set += 1;
                                $("#btnSave").attr('disabled', false);
                            }
                            if (set >= 2) {
                                $("#btnSave").attr('disabled', false);
                            }
                            if (eval($row.find('#tdSetQuantity').text()) <= eval($row.find('#tdReceivedQty').text())) {
                                $row.find('#txtRecieveNew').focus().val(Number(ToBeReceiveQty));
                            }
                            else {
                            }
                            CheckQtyRecive($row.find('#txtRecieveNew'));
                        });

                    }
                    else {

                        $('#PatientLabSearchOutput').hide();
                        $("#btnSave").hide();
                        modelAlert('Stock Not Available');
                        return;
                    }

                });

            });
        }


        var getSetStockId = function (setId, callback) {
            serverCall('Services/SetItems.asmx/SetStockID', { SetID: setId }, function (response) {
                if (response != "") {
                    $("#lblSetStockID").text(response);
                }
                else {
                    $("#lblSetStockID").text('');
                }
                callback(response);

            });

        }



        function DeleteRow(rowid) {
        }
        function CheckQty(RecievedQty) {
            if (eval($(RecievedQty).val()) > eval($(RecievedQty).closest('tr').find('#StockQty').text())) {
                modelAlert('Received Quantity cannot greater than Stock Quantity');
                $(RecievedQty).val('0');
                return;
            }
            var TotalSetQunatity = $(RecievedQty).closest('table').closest('tr').find('#tdSetQuantity').text();
            var total = 0;
            $(RecievedQty).closest('table').find("#txtRecievedQty").each(function () {
                total = eval(total + eval($(this).val()));
            });
            if (eval(total) > eval(TotalSetQunatity)) {
                modelAlert('Received Quantity cannot be greater than Total Set Quantity');
                $(RecievedQty).val('0');
                return;
            }
        }
        function CheckQtyRecive(RecievedQty) {
            var Amt = $(RecievedQty).val();
            if (Amt.match(/[^0-9]/g)) {
                Amt = Amt.replace(/[^0-9]/g, '');
                $(RecievedQty).val(Number(Amt));
                return;
            }
            $(RecievedQty).val(Number(Amt));
            var total = 0;
            var TotalSetQunatity = $(RecievedQty).closest('tr').find('#tdSetQuantity').text();
            var TotalStockQunatity = $(RecievedQty).closest('tr').find('#tdReceivedQty').text();
            total = eval($(RecievedQty).val());
            var TotalReceiveQty = $(RecievedQty).closest('tr').find('#tdReceiveQty').text();
            if (total == 0) {
                $(RecievedQty).closest('td').find("#tb_grdStockData tr").each(function () {
                    if ($(this).attr("id") != "HeaderStock") {
                        $(this).find('#txtRecievedQty').val('0');
                    }
                });

                $(RecievedQty).val('0');
                modelAlert('Please Enter Quantity');
                return;
            }

            if (eval(total) > eval(eval(TotalSetQunatity) - eval(TotalReceiveQty))) {
                modelAlert('Received Quantity cannot be greater than Total Set Quantity');
                $(RecievedQty).val("0");
                $(RecievedQty).closest('td').find("#tb_grdStockData tr").each(function () {
                    if ($(this).attr("id") != "HeaderStock") {
                        $(this).find('#txtRecievedQty').val('0');
                    }
                });
                return;
            }

            if (eval(total) > eval(TotalStockQunatity)) {
                modelAlert('Received Quantity cannot be greater than Stock Quantity');
                $(RecievedQty).val('0');
                $(RecievedQty).closest('td').find("#tb_grdStockData tr").each(function () {
                    if ($(this).attr("id") != "HeaderStock") {
                        $(this).find('#txtRecievedQty').val('0');
                    }
                });
                return;
            }
            var quantity = total;
            $(RecievedQty).closest('td').find("#tb_grdStockData tr").each(function () {

                if ($(this).attr("id") != "HeaderStock" && Number(quantity) > 0) {
                    var StockQty = $(this).find('#StockQty').text();

                    if (Number(quantity) > Number(StockQty)) {
                        $(this).find('#txtRecievedQty').val(StockQty);
                        quantity = Number(quantity) - Number(StockQty);
                    }
                    else {
                        $(this).find('#txtRecievedQty').val(quantity);
                        quantity = 0;
                    }
                }
            });
        }
        function SetStockID() {
            if ($("#ddlSetItem").val() != 0) {
                $("#lblSetStockID").text('');


                serverCall('Services/SetItems.asmx/SetStockID', { SetID: $("#ddlSetItem").val() }, function (response) {

                    if (response != "") {
                        $("#lblSetStockID").text(response);
                    }
                    else {
                        $("#lblSetStockID").text('');
                    }



                });


            }
        }
    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Process Item Quantity In Set</b>
            <br />
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"> </asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Sets
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlSetItem" runat="server" ToolTip="Select Sets" ClientIDMode="Static" CssClass="requiredField">
                            </asp:DropDownList>
                            <input id="btnAdd" value="Add" type="button" class="ItDoseButton" style="display: none" />
                            <asp:Label ID="lblSetStockID" runat="server" Style="display: none" Text="" ClientIDMode="Static"></asp:Label>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Result
            </div>
            <table style="width: 100%; border-collapse: collapse">
                <tr>
                    <td style="text-align: left" colspan="3">
                        <div id="PatientLabSearchOutput" style="max-height: 400px; overflow-y: scroll;">
                        </div>
                    </td>
                </tr>
                <tr>
                <td colspan="3" style="text-align: center;">
                    <input id="btnSave" value="Save" type="button" class="ItDoseButton" title="Click To Save" style="width:100px;margin-top:7px;" />
                </td>
            </tr>
            </table>
        </div>
    </div>
    <script id="tb_PatientLabSearch" type="text/html">
    <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdLabSearch"
    style="width:100%;border-collapse:collapse;">
		<tr>
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;">Set ID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:140px;">Set Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:70px; display:none">Item ID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:70px; display:none">Stock ID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:280px;">Item Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:30px;">Master Qty.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:30px;">Stock Qty.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:20px;display:none">Setstock Id</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:30px;">Processed Qty.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Qty.To Process</th>                     
		</tr>
        <#      
        var dataLength=PatientData.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;
        for(var j=0;j<dataLength;j++)
        {
        objRow = PatientData[j];
          #>
                    <tr id="<#=objRow.SetID#>|<#=objRow.ItemID#>" >
                        <td class="GridViewLabItemStyle"><#=j+1#></td>
                        <td id="SetID" class="GridViewLabItemStyle" style="text-align:center"><#=objRow.SetID#></td>
                        <td id="SetName" class="GridViewLabItemStyle" style="text-align:center"><#=objRow.SetName#></td>
                        <td id="ItemID" class="GridViewLabItemStyle" style="display:none"><#=objRow.ItemID#></td>
                         <td id="stockID" class="GridViewLabItemStyle" style="display:none"><#=objRow.StockID#></td>
                        <td id="ItemName" class="GridViewLabItemStyle"><#=objRow.ItemName#></td>
                        <td id="tdSetQuantity" class="GridViewLabItemStyle" style="text-align:right"><#=objRow.SetQuantity#></td>
                        <td id="tdReceivedQty" class="GridViewLabItemStyle" style="text-align:right"><#=objRow.StockQtyNew#></td>
                        <td id="tdsetstockid" class="GridViewLabItemStyle" style="display:none"><#=objRow.SetstockId#></td> 
                         <td id="tdReceiveQty" class="GridViewLabItemStyle" style="text-align:right"><#=objRow.ReceivedQty#>                
                         </td>   
                    <td  class="GridViewLabItemStyle" style="text-align:center; vertical-align:middle;">
                         <input id="txtRecieveNew" size="5" type="text" onpaste="return false"  class="ItDoseTextinputNum" title="Enter Qty. To Receive" onkeyup="CheckQtyRecive(this);" 
                         <#if(objRow.ReceivedQty==objRow.SetQuantity){#>
                          disabled="disabled"<#}#> 
                          />
                         <##>                                     
                          <table cellspacing="0" rules="all" border="1" id="tb_grdStockData"
                              style="display:none;width:1px;height:0px;table-layout:fixed;overflow:hidden; white-space:">
		                        <tr id="HeaderStock"  >
			                    <th scope="col" >StockID</th>
			                    <th scope="col" >StockQty</th>
			                    <th scope="col" >QtyToRecieve</th>
			                    </tr>
                               <# 
                                  var StockQty=objRow.StockQty.split('$'); 
                                  var StockID=objRow.StockID.split('$'); 
                                   var dlen=StockID.length;
                                   for(var i=0;i<dlen;i++)
                                    { 
                                #>
                               <tr id="<#=StockID[i]#>" >
                               <td  ><#=StockID[i]#></td>
                               <td  id="StockQty" ><#=StockQty[i]#></td>
                               <td ><input id="txtRecievedQty" type="text" class="ItDoseTextinputNum"  size="2" value="0" onkeyup="CheckQty(this);" /></td>
                                </tr>     
                              <#}#>
                            </table>                                                        
               </td>
                </tr>
            <#}#>
     </table>    
    </script>
</asp:Content>
