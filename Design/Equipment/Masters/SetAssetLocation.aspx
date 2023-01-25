<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master" CodeFile="SetAssetLocation.aspx.cs"
    Inherits="Design_Equipment_Masters_SetAssetLocation" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
     <script src="../../../Scripts/jquery.easyui.min.js" type="text/javascript"></script>
    <link href="../../../Styles/easyui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(document).ready(function () {
            
            
            LoadAssetItems(function (callback) {
                    $commonJsInit(function () {
                        $('.textbox-text.validatebox-text').attr('tabindex', 6);
                        $("#HDPageLoaded").val('1');
                        SearchAsset(function () { });
                        $('#ctl00_ContentPlaceHolder1_ddlEditDept').attr('disabled', true);
                        $('#ctl00_ContentPlaceHolder1_ddlDepartment').attr('disabled', true);
                    });
                });
            
        });
       
        function EditAssets(RoomID,DepartmentID,StockID) {
            $('#<%=ddlDepartment.ClientID%>').val(DepartmentID);
            $('#<%=ddlRooms.ClientID%>').val(RoomID);
            $("#hdStockID").val(StockID);
            $("#tblSelectedItems").find("tr:gt(0)").remove();
            $("#divSelectedItems").hide();
            $("#divAction").hide();
            $("#tbl_AssetDetails tr").css('background-color', '');
            $('#tr' + StockID).css('background-color', '#ffbc00');
            LoadAssetItems(function () {
                $('#txtItemSearch').combogrid('setValue', StockID);
            });
        }

        function checkForSecondDecimal(sender, e) {

            var charCode = (e.which) ? e.which : e.keyCode;
            if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }

            if (sender.value == "0") {
                sender.value = sender.value.substring(0, sender.value.length - 1);
            }

            strLen = sender.value.length;
            strVal = sender.value;
            hasDec = false;
            if (charCode == '46') {
                return false;
            }

            e = (e) ? e : (window.event) ? event : null;

            if (e) {
                var charCode = (e.charCode) ? e.charCode :
                            ((e.keyCode) ? e.keyCode :
                            ((e.which) ? e.which : 0));

                if ((charCode == 46) || (charCode == 110) || (charCode == 190)) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '.');
                        if (hasDec)
                            return false;
                    }
                }
            }
            return true;

        }
        function SearchAsset(callback) {
            var FromDate = $('#<%=ucFromDate.ClientID%>').val();
            var ToDate = $('#<%=ucToDate.ClientID%>').val();
            var EditDeptID = $('#<%=ddlEditDept.ClientID%>').val();
            var EditRoomID = $('#<%=ddlEditRoom.ClientID%>').val();
            $("#tbl_AssetDetails").find("tr:gt(0)").remove();
            var QueryType = $("#HDPageLoaded").val();
            $.ajax({
                url: "SetAssetLocation.aspx/GetAssetDetails",
                data: JSON.stringify({ FromDate: FromDate, ToDate: ToDate, EditDeptID: EditDeptID, EditRoomID: EditRoomID, QueryType: QueryType }),
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (result) {

                    Asset_Details = eval('[' + result.d + ']');
                    if (Asset_Details.length == 0) {
                        modelAlert("No Data Found");
                        return;
                    }
                    else {
                        
                        for (var a = 0; a <= Asset_Details.length - 1; a++) {
                          var table = $('#tbl_AssetDetails tbody');
                            var newRow = $('<tr />').attr('id', 'tr' + Asset_Details[a].StockId);
                            newRow.html(
                                              '</td><td class="GridViewLabItemStyle" id="tdSrNo" style="text-align:center">' + (table.find('tr').length + 1) +
                                              '</td><td class="GridViewLabItemStyle" id="tdItemName">' + Asset_Details[a].AssetName +
                                              '</td><td class="GridViewLabItemStyle"  id="tdQty">' + Asset_Details[a].qty +
                                              '</td><td class="GridViewLabItemStyle"  id="tdDepartment">' + Asset_Details[a].Department +
                                              '</td><td class="GridViewLabItemStyle"  id="tdRoomName">' + Asset_Details[a].RoomName +
                                              '</td><td class="GridViewLabItemStyle"  id="tdSubmitBy">' + Asset_Details[a].SubmitBy +
                                              '</td><td class="GridViewLabItemStyle"  id="tdSubmitDate">' + Asset_Details[a].insertdate +
                                              '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none"  id="tdRoomID">' + Asset_Details[a].RoomID +
                                              '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="tdstockid">' + Asset_Details[a].StockId +
                                              '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="tdItemID">' + Asset_Details[a].ItemId +
                                              '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="tdDeptID">' + Asset_Details[a].DepartmentID +
                                              '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="tdAssetID">' + Asset_Details[a].AssetID +
                                              '</td><td class="GridViewLabItemStyle" style="text-align:center;" id="tdEdit"><input type="button" id="btnEdit" onclick="EditAssets(\'' + Asset_Details[a].RoomID + '\',\'' + Asset_Details[a].DepartmentID + '\',\'' + Asset_Details[a].StockId + '\')" value="Edit"/></td>'
                                              );
                            table.append(newRow);
                            $('#divAssetDetails').show();
                            $("#HDPageLoaded").val('0');
                        }


                    }
                },
                error: function (xhr, status) {

                    window.status = status + "\r\n" + xhr.responseText;
                }

            });

            callback(true);
        }
        function LoadRooms(ddlID) {
            
            var DeptID = "";
            var ddlrooms = "";
            if (ddlID == "1") {
                 DeptID = $('#<%=ddlDepartment.ClientID%>').val();
                 ddlrooms = $('#<%=ddlRooms.ClientID%>');
            }
            else {
                 DeptID = $('#<%=ddlEditDept.ClientID%>').val();
                 ddlrooms = $('#<%=ddlEditRoom.ClientID%>');
            }
            ddlrooms.empty();
            $.ajax({
                url: "SetAssetLocation.aspx/LoadRooms",
                data: JSON.stringify({ DeptID: DeptID }),
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (result) {
                    RoomsRecord = eval('[' + result.d + ']');

                    ddlrooms.append($("<option></option>").val('0').html("Select"));
                    for (var a = 0; a <= RoomsRecord.length - 1; a++) {
                        ddlrooms.append($("<option></option>").val(RoomsRecord[a].RoomID).html(RoomsRecord[a].RoomName));
                    }
                    
                },
                error: function (xhr, status) {

                    window.status = status + "\r\n" + xhr.responseText;
                }

            });
        }

        function LoadEditRooms() {
            var DeptID = $('#<%=ddlEditDept.ClientID%>').val();
            var ddlrooms = $('#<%=ddlEditRoom.ClientID%>');
            ddlrooms.empty();
            $.ajax({
                url: "SetAssetLocation.aspx/LoadRooms",
                data: JSON.stringify({ DeptID: DeptID }),
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (result) {
                    RoomsRecord = eval('[' + result.d + ']');

                    for (var a = 0; a <= RoomsRecord.length - 1; a++) {
                        ddlrooms.append($("<option></option>").val(RoomsRecord[a].RoomID).html(RoomsRecord[a].RoomName));
                    }
                },
                error: function (xhr, status) {

                    window.status = status + "\r\n" + xhr.responseText;
                }

            });
        }

        var LoadAssetItems = function (callback) {
            try {
                getComboGridOption(function (response) {
                  
                    $('#txtItemSearch').combogrid(response);
                   
                    callback(true);
                });
            } catch (e) {

            }
        }
      
        var getComboGridOption = function (callback) {
            var setting = {
                panelWidth: 800,
                idField: 'StockID',
                textField: 'ItemName',
                mode: 'remote',
                url: '../Services/AssetItems.asmx/LoadItems?cmd=item',
                loadMsg: 'Searching... ',
                method: 'get',
                pagination: true,
                pageSize: 20,
                rownumbers: true,
                fit: true,
                border: false,
                cache: false,
                nowrap: true,
                emptyrecords: 'No records to display.',
                queryParams: {
                    q:'',
                    stock_id: $("#hdStockID").val(),
                    DeptLedgerNo: $('#lblDeptLedgerNo').text().trim()
                },
                onHidePanel: function () { },
                columns: [[
                    { field: 'ItemName', title: 'ItemName', align: 'left', sortable: true },
                    { field: 'serialno', title: 'SerialNo.', align: 'center', sortable: true },
                     { field: 'AvailableQty', title: 'Available Qty', align: 'center', sortable: true },
                    { field: 'warrantyto', title: 'Warranty To.', align: 'right', sortable: true },
                    { field: 'IGSTPercent', title: 'IGST Percentage', align: 'center', sortable: true },
                    { field: 'CGSTPercent', title: 'CGST Percentage', align: 'right', sortable: true },
                    { field: 'SGSTPercent', title: 'SGST Percentage', align: 'center' }
                    //{ field: 'StockID', title: 'Stock ID', align: 'center' }
                   
                ]],
                fitColumns: true,
                rowStyler: function (index, row) {
                    if (row.alterNate > 0) {
                        return 'background-color:antiquewhite;';
                    }
                }
            }
            callback(setting);
        }

        var addItem = function (e) {
            var txtItemSearch = $('#txtItemSearch');
            
            var quantity ="1";
            var grid = txtItemSearch.combogrid('grid');
            var selectedRow = grid.datagrid('getSelected');

            var RoomID = $('#<%=ddlRooms.ClientID%>').val();
            if (RoomID == "0") {
                modelAlert('Kindly select Room', function () { });
                return;
            }
          
                var code = (e.keyCode ? e.keyCode : e.which);
                if (String.isNullOrEmpty(selectedRow)) {
                    modelAlert('Please Select Item First', function () {
                        $('.textbox-text.validatebox-text').focus();
                        txtItemSearch.combogrid('reset');
                    });
                    return;
                }

                var stockID = $.trim(selectedRow.StockID);
                var RoomName = $('#<%=ddlRooms.ClientID%> option:selected').text();
                

                if (quantity > selectedRow.AvailableQty) {
                    modelAlert('Receiving quantity cant be greather than avail quantity', function () {
                        $("#ctl00_ContentPlaceHolder1_txtQty").val('');
                      
                    });
                    return;
                }

                var alreadySelectBool = $('#tr_' + stockID).length > 0 ? true : false;
                if (alreadySelectBool) {
                    modelAlert('Item Already Added', function () {
                        $("#ctl00_ContentPlaceHolder1_txtQty").val('');
                        $('.textbox-text.validatebox-text').focus();
                        txtItemSearch.combogrid('reset');
                    });
                    return;
                }
                if (quantity == 0)
                    return;
                var itemID = selectedRow.ItemID;
                var SerialNos = selectedRow.serialno;
                var warrantyTo = selectedRow.warrantyto;
                var IgstPercentage = selectedRow.IGSTPercent;
                var CgstPercentage = selectedRow.CGSTPercent;
                var SgstPercentage = selectedRow.SGSTPercent;
                

                var Item_Name = selectedRow.ItemName;
                var Department = $('#<%=ddlDepartment.ClientID%> option:selected').text();
                var DeptID = $('#<%=ddlDepartment.ClientID%>').val();
                var assetid = selectedRow.assetid;


                if (code == 13 && e.target.type == 'text') {
                    quantity = e.target.value;
                    bindItem(itemID, quantity, stockID, SerialNos, warrantyTo, IgstPercentage, CgstPercentage, SgstPercentage, RoomID, RoomName, Item_Name, Department, DeptID, assetid, function () {
                        $("#ctl00_ContentPlaceHolder1_txtQty").val('');
                        $('.textbox-text.validatebox-text').focus();
                        txtItemSearch.combogrid('reset');
                    });
                }
                else if (e.target.type == 'submit') {
                    bindItem(itemID, quantity, stockID, SerialNos, warrantyTo, IgstPercentage, CgstPercentage, SgstPercentage, RoomID, RoomName, Item_Name, Department, DeptID, assetid, function () {
                        $("#ctl00_ContentPlaceHolder1_txtQty").val('');
                        $('.textbox-text.validatebox-text').focus();
                        txtItemSearch.combogrid('reset');
                    });
                }

                if (code == 9 && e.target.type == 'text') {
                    $(this).parent().find('input[type=button]').focus();
                }

         //   }
        }

        
        var bindItem = function (itemID, quantity, stockID, SerialNos, warrantyTo, IgstPercentage, CgstPercentage, SgstPercentage, RoomID, RoomName, Item_Name, Department, DeptID,assetid, callback) {
           // getItemDetails(itemID, quantity, stockID, function (response) {
              
            addNewRow(itemID, quantity, stockID, SerialNos, warrantyTo, IgstPercentage, CgstPercentage, SgstPercentage, RoomID, RoomName, Item_Name, Department, DeptID,assetid, function () {
                  //  calculateTotal(function (total) {
                    //    callback();
                   // });
                });
          // 
        }



        var addNewRow = function (itemID, quantity, stockID, SerialNos, warrantyTo, IgstPercentage, CgstPercentage, SgstPercentage, RoomID, RoomName, Item_Name, Department, DeptID,assetid, callback) {
       
            var table = $('#tblSelectedItems tbody');
            var newRow = $('<tr />').attr('id', 'tr_' + stockID);
            newRow.html(
                              '</td><td class="GridViewLabItemStyle" id="tdSrNo" style="text-align:center">' + (table.find('tr').length + 1) +
                              '</td><td class="GridViewLabItemStyle" id="tdItemName">' + Item_Name +
                              '</td><td class="GridViewLabItemStyle" id="tdserialno" style="text-align:center">' + SerialNos +
                              '</td><td class="GridViewLabItemStyle" id="tdwarrantyto" ">' + warrantyTo +
                              '</td><td class="GridViewLabItemStyle" id="tdIGSTPercent">' + IgstPercentage +
                              '</td><td class="GridViewLabItemStyle" style="text-align:center;" id="tdCGSTPercent">' + CgstPercentage +
                              '</td><td class="GridViewLabItemStyle"  id="tdSGSTPercent">' + SgstPercentage +
                              '</td><td class="GridViewLabItemStyle"  id="tdQty">' + quantity +
                              '</td><td class="GridViewLabItemStyle"  id="tdDepartment">' + Department +
                              '</td><td class="GridViewLabItemStyle"  id="tdRoomName">' + RoomName +
                              '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none"  id="tdRoomID">' + RoomID +
                              '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="tdstockid">' + stockID +
                              '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="tdItemID">' + itemID +
                              '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="tdDeptID">' + DeptID +
                              '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="tdAssetID">' + assetid +
                              '</td><td class="GridViewLabItemStyle" style="text-align:center;" id="imgPhRemove"><img id="imgRmv" class="btn" src="/his/Images/Delete.gif" onclick="removeAsset(this);" style="cursor:pointer;" title="Click To Remove"></td>'
                              );
            table.append(newRow);
            callback(true);
            $('#divSelectedItems').show();
            $('#divAction').show();
            if ($("#hdStockID").val() != "")
                $("#btnSave").attr('value', 'Update');
            var txtItemSearch = $('#txtItemSearch');
            txtItemSearch.combogrid('reset');
        }




        var removeAsset = function (elem) {
            $(elem).parent().parent().remove();
            if($("#tblSelectedItems tr").length-1=="0")
                $('#divAction').hide();
        }

        var clearSelectedMedicines = function (callback) {
            $('#divSelectedMedicine table tbody tr').remove();
            calculateTotal(function (total) {
                callback();
            });
        }


        function saveAssetLocation() {
            var Tabledata = getTableData();
            var Update_stockID = $("#hdStockID").val();
            $.ajax({
                url: "SetAssetLocation.aspx/SaveAssetLocation",
                data: JSON.stringify({ AssetTableData: Tabledata, Update_stockID: Update_stockID }),
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {

                    if (result.d == "-1") {
                        modelAlert('Record Not Saved !!');
                        

                    }
                    else if (result.d == "-2") {
                        modelAlert('Asset Already Recieved !!');
                        
                    }
                    else {
                        if (Update_stockID == "") {
                            $("#HDPageLoaded").val('1');
                            SearchAsset(function (callback) {
                                LoadAssetItems(function () {

                                    modelAlert('Record Saved');
                                });
                            });
                            
                        }
                        else {
                            $('#txtItemSearch').combogrid('reset');
                            $("#hdStockID").val('');
                            SearchAsset(function (callback) {
                                
                                LoadAssetItems(function () {
                                   
                                   
                                    $("#btnSave").attr('value', 'Save');
                                    modelAlert('Record Updated');
                                });
                            });
                            
                        }
                        $("#tblSelectedItems").find("tr:gt(0)").remove();
                        $("#ctl00_ContentPlaceHolder1_txtQty").val('');
                        $('.textbox-text.validatebox-text').focus();
                        var txtItemSearch = $('#txtItemSearch');
                        txtItemSearch.combogrid('reset');
                        $("#divSelectedItems").hide();
                        $("#divAction").hide();
                    }
                },
                error: function (xhr, status) {
                    alert(xhr.responseText);
                }
            });

        }

        function ValidateDuplicates() {
            var temp;
            var txtItemSearch = $('#txtItemSearch');
           var grid = txtItemSearch.combogrid('grid');
            var selectedRow = grid.datagrid('getSelected');
            var stockID = $.trim(selectedRow.StockID);
            $.ajax({
                url: "SetAssetLocation.aspx/CheckDuplicate",
                data: JSON.stringify({ StockID: stockID }),
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {

                    if (result.d == "1") {
                        modelAlert
                        modelAlert("Asset Already Recieved!!");
                        temp= false;
                    }
                    if (result.d == "0") {
                        temp= true;
                       
                    }
                },
                error: function (xhr, status) {
                    alert(xhr.responseText);
                }
            });

            return temp;
        }
        function getTableData() {
            var tempData = [];

            $('#tblSelectedItems tr').each(function () {

                if ($(this).attr("id") != "IssueItemHeader") {
                    var Asset_Location = [];

                    Asset_Location[0] = $(this).find('#tdItemName').text();//itemname
                    Asset_Location[1] = $(this).find('#tdserialno').text();
                    Asset_Location[2] = $(this).find('#tdwarrantyto').text();
                    Asset_Location[3] =  $(this).find('#tdIGSTPercent').text();
                    Asset_Location[4] = $(this).find('#tdCGSTPercent').text();


                    Asset_Location[5] = $(this).find('#tdSGSTPercent').text();


                    Asset_Location[6] = Number($(this).find('#tdQty').text());
                    Asset_Location[7] = $(this).find('#tdDepartment').text();
                    Asset_Location[8] = $(this).find('#tdRoomName').text();
                    Asset_Location[9] = $(this).find('#tdRoomID').text();
                    Asset_Location[10] = $(this).find('#tdstockid').text();


                    Asset_Location[11] = $(this).find('#tdItemID').text();//itemid
                    Asset_Location[12] = $(this).find('#tdDeptID').text();
                    Asset_Location[13] = $(this).find('#tdAssetID').text();
                     tempData.push(Asset_Location);

                }

            });
            return tempData;
        }



      



        


       
    </script>


    
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory">
                <asp:ScriptManager ID="smManager" runat="server"></asp:ScriptManager>
                <div style="text-align: center">
                    <b>Set Asset Location<br />
                        <asp:Label  ID="lblDeptLedgerNo" runat="server" style="display:none" ClientIDMode="Static" ></asp:Label>
                        <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                        <input type="hidden" id="hdStockID" />
                       <input type="hidden" id="HDPageLoaded" />
                    </b>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center; ">
                <div style="text-align: center">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Departments </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                           <asp:DropDownList ID="ddlDepartment" onchange="LoadRooms(1)" runat="server" CssClass="requiredField"></asp:DropDownList>
                                
                        </div>
                        <div class="col-md-2">
                            <label class="pull-left">Rooms </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                           <asp:DropDownList ID="ddlRooms" runat="server" CssClass="requiredField"></asp:DropDownList>
                                
                        </div>
                        <div class="col-md-2">
                            <label class="pull-left">Asset </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5 pull-left">
                            <input type="text" id="txtItemSearch" tabindex="6" class="easyui-combogrid requiredField" />
                        </div>
                       <div class="col-md-1">
                            <asp:Button ID="btnAdd" runat="server" Text="Add" OnClientClick="addItem(event); return false;"  CssClass="ItDoseButton" />
                                
                        </div>
                    </div>

                    <div class="row">
                         
                        
                        <div style="display:none" class="col-md-3">
                            <label class="pull-left">Qty </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div style="display:none" class="col-md-5">
                            <asp:TextBox ID="txtQty"  onkeypress="return checkForSecondDecimal(this,event)" runat="server" CssClass="requiredField"></asp:TextBox>
                                
                        </div>
                        
                        
                    </div>

                    
                </div>
            </div>
    
               <div  id="divSelectedItems" class="POuter_Box_Inventory" style="display:none">
            <table id="tblSelectedItems" style="width: 100%; border-collapse: collapse;">
                <thead>
                    <tr id="IssueItemHeader">
                        <th class="GridViewHeaderStyle" scope="col">S.No.</th>
                        <th class="GridViewHeaderStyle" scope="col">Item Name</th>
                        <th class="GridViewHeaderStyle" scope="col">Serial No.</th>
                        <th class="GridViewHeaderStyle" scope="col"  >Warranty To</th>
                        <th class="GridViewHeaderStyle" scope="col">IGST Percent</th>
                        <th class="GridViewHeaderStyle" scope="col">CGST Percent</th>
                        <th class="GridViewHeaderStyle" scope="col">SGST Percent</th>
                        <th class="GridViewHeaderStyle" scope="col">Quantity</th>
                        <th class="GridViewHeaderStyle" scope="col">Department</th>
                        <th class="GridViewHeaderStyle" scope="col">Room Name</th>
                        <th class="GridViewHeaderStyle" scope="col" style="display:none">RoomID</th>
                        <th class="GridViewHeaderStyle" scope="col" style="display:none">Stockid</th>
                     <th class="GridViewHeaderStyle" scope="col" style="display:none">ItemID</th>
                        <th class="GridViewHeaderStyle" scope="col" style="display:none">DeptID</th>
                        <th class="GridViewHeaderStyle" scope="col" style="display:none">AssetID</th>
                        <th class="GridViewHeaderStyle" scope="col">Remove</th>
                    </tr>
                </thead>
                <tbody>
                </tbody>
            </table>

        </div>
            <div class="POuter_Box_Inventory" id="divAction" style="text-align: center; display: none">
            <input type="button" id="btnSave" style="margin-top:7px" class="ItDoseButton save" onclick="saveAssetLocation();" value="Save" tabindex="35" />
        </div>

            

                
            <div class="POuter_Box_Inventory" id="divAssetSearch" style="text-align: center;">
                 <div style="padding: 1px;" class="Purchaseheader">
                    Search Asset Location
                        
                    
                </div>
                <div class="row">
            <div class="col-md-3">
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ucFromDate" AutoCompleteType="Disabled" runat="server" ToolTip="Click To Select From Date"
                                ClientIDMode="Static" TabIndex="5"></asp:TextBox>
                            <cc1:CalendarExtender ID="fc1" runat="server" TargetControlID="ucFromDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ucToDate" AutoCompleteType="Disabled" runat="server"  ClientIDMode="Static" 
                            ToolTip="Click To Select To Date"></asp:TextBox>
                        <cc1:CalendarExtender ID="fc2" runat="server" TargetControlID="ucToDate" Format="dd-MMM-yyyy">
                        </cc1:CalendarExtender>
                        </div>
                    </div>
                <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Departments </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                           <asp:DropDownList ID="ddlEditDept" onchange="LoadRooms('2')" runat="server" ></asp:DropDownList>
                                
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Rooms </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                           <asp:DropDownList ID="ddlEditRoom" runat="server" ></asp:DropDownList>
                                
                        </div>
                        <div class="col-md-1">
                            <input type="button" onclick="SearchAsset(function () { })" value="Search" />
                          
                                
                        </div>
                       
                    </div>
        </div>

            <div  id="divAssetDetails" class="POuter_Box_Inventory" style="display:none">
            <table id="tbl_AssetDetails" style="width: 100%; border-collapse: collapse;">
                <thead>
                    <tr id="header">
                        <th class="GridViewHeaderStyle" scope="col">S.No.</th>
                        <th class="GridViewHeaderStyle" scope="col">Item Name</th>
                       
                        <th class="GridViewHeaderStyle" scope="col">Quantity</th>
                        <th class="GridViewHeaderStyle" scope="col">Department</th>
                        <th class="GridViewHeaderStyle" scope="col">Room Name</th>
                        <th class="GridViewHeaderStyle" scope="col">Submitted By</th>
                        <th class="GridViewHeaderStyle" scope="col">Submit Date</th>
                        <th class="GridViewHeaderStyle" scope="col" style="display:none">RoomID</th>
                        <th class="GridViewHeaderStyle" scope="col" style="display:none">Stockid</th>
                     <th class="GridViewHeaderStyle" scope="col" style="display:none">ItemID</th>
                        <th class="GridViewHeaderStyle" scope="col" style="display:none">DeptID</th>
                        <th class="GridViewHeaderStyle" scope="col" style="display:none">AssetID</th>
                        <th class="GridViewHeaderStyle" scope="col">Edit</th>
                    </tr>
                </thead>
                <tbody>
                </tbody>
            </table>

        </div>
        </div>
    


    </asp:Content>