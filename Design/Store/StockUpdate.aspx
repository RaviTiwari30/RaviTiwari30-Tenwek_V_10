<%@ Page Language="C#" AutoEventWireup="true" CodeFile="StockUpdate.aspx.cs" Inherits="Design_Store_StockUpdate"
    MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript" src="../../Scripts/Search.js"></script>

    <script type="text/javascript">
        var keys = [];
        var values = [];
        $(document).ready(function () {
            AddRemoveAttrinbute();//

            $('#<%=txtIGST.ClientID %>,#<%=lblIGST.ClientID %>,#<%=lblUTGST.ClientID %>').hide();
            var options = $('#<% = lstItem.ClientID %> option');
            $.each(options, function (index, item) {
                keys.push(item.value);
                values.push(item.innerHTML);
            });
            $('#<% = txtFirstNameSearch.ClientID %>').keyup(function (e) {
                searchByFirstChar(document.getElementById('<%=txtFirstNameSearch.ClientID%>'), document.getElementById('<%=txtCPTCodeSearch.ClientID%>'), document.getElementById('<%=txtInBetweenSearch.ClientID%>'), document.getElementById('<%=lstItem.ClientID%>'), "", values, keys, e);
                LoadDetail();
            });
            $('#<%=txtCPTCodeSearch.ClientID %>').keyup(function (e) {
                searchByCPTCode(document.getElementById('<%=txtFirstNameSearch.ClientID%>'), document.getElementById('<%=txtCPTCodeSearch.ClientID%>'), document.getElementById('<%=txtInBetweenSearch.ClientID%>'), document.getElementById('<%=lstItem.ClientID%>'), "", values, keys, e);
                LoadDetail();
            });
            $('#<%=txtInBetweenSearch.ClientID %>').keyup(function (e) {
                searchByInBetween(document.getElementById('<%=txtFirstNameSearch.ClientID%>'), document.getElementById('<%=txtCPTCodeSearch.ClientID%>'), document.getElementById('<%=txtInBetweenSearch.ClientID%>'), document.getElementById('<%=lstItem.ClientID%>'), "", values, keys, e);
                LoadDetail();
            });
        });
        function AddRemoveAttrinbute() {
            if ('<%=Resources.Resource.IsGSTApplicable%>' == '0') {
                $('#<%=ddlPurTax.ClientID%>').removeAttr("onchange");
            }
            
            if ('<%=Resources.Resource.IsGSTApplicable%>' == '1') {
                $('#<%=txtPrice.ClientID%>').removeAttr("onkeyup");
                $('#<%=txtDisc.ClientID%>').removeAttr("onkeyup"); 
                $('#<%=txtDisc.ClientID%>').attr("onkeyup", "ValidateDisc()");
                $('#<%=txtQty.ClientID%>').removeAttr("onkeyup"); 
            }
        }
        function ClickSelectbtn(e, btnName) {
            if (window.event.keyCode == 13) {
                var btn = document.getElementById(btnName);
                alert(btn);
                if (btn != null) { //If we find the button click it
                    btn.click();
                    event.keyCode = 0
                    return false;
                }
            }
        }
        function checkForSecondDecimal(sender, e) {
            formatBox = document.getElementById(sender.id);
            strLen = sender.value.length;
            strVal = sender.value;
            hasDec = false;
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
        function validatedot() {
            if (($("#<%=txtQty.ClientID%>").val().charAt(0) == ".")) {
                $("#<%=txtQty.ClientID%>").val('');
                return false;
            }
            return true;
        }
        function ValidateDisc() {
            var DiscPer = $('#<%=txtDisc.ClientID %>').val();
            var Taxper = 0;
            if ('<%=Resources.Resource.IsGSTApplicable%>' == '0') {
                Taxper = $('#<%=txtTAX1.ClientID %>').val();
            }
            else {
                Taxper = ($('#<%=txtIGST.ClientID %>').val() + $('#<%=txtCGST.ClientID %>').val() + $('#<%=txtSGST.ClientID %>').val());
            }

            if (Number(DiscPer) > 100) {
                $('#<%=txtDisc.ClientID %>').val('');
                alert('Invalid Discount');
            }
            if ('<%=Resources.Resource.IsGSTApplicable%>' == '0') {
                if (Number(Taxper) > 100) {
                    $('#<%=txtTAX1.ClientID %>').val('');
                    alert('Invalid Purchase Tax');
                }
            }
            else {
                if (Number(Taxper) > 100) {
                    $('#<%=txtIGST.ClientID %>').val("0.00");
                    $('#<%=txtCGST.ClientID %>').val('0.00');
                    $('#<%=txtSGST.ClientID %>').val('0.00');
                    alert('Invalid Purchase Tax');
                }
            }
        }
        $(document).ready(function () {
            $('#btnView').click(function (e) {
                var selectedOpts = $('#<%=lstItem.ClientID %> option:selected').length;
                $("#div_InvestigationItems").empty();
                $('#<%=lblMsg.ClientID %>').text('');
                if (selectedOpts != 0) {
                    $.ajax({
                        url: "Services/WebService.asmx/ShowStock",
                        data: '{ ItemId:"' + $('#<%=lstItem.ClientID %> option:selected').val() + '"}', // parameter map
                        type: "POST", // data has to be Posted    	        
                        contentType: "application/json; charset=utf-8",
                        timeout: 120000,
                        dataType: "json",
                        success: function (result) {
                            Data = jQuery.parseJSON(result.d);
                            if (Data.length > 0) {
                                $("#div_InvestigationItems").empty();
                                if ('<%=Resources.Resource.IsGSTApplicable%>' == '0') {
                                    var table = "<table id='tblResult' cellspacing='0' rules='all' border='1'><tr > <th class='GridViewHeaderStyle' style='width:20px; ' scope='col'>S.No.</th><th class='GridViewHeaderStyle' style='width:100px;' scope='col'>Quantity</th> <th class='GridViewHeaderStyle' style='width:70px;'>BatchNumber</th> <th class='GridViewHeaderStyle' style='width:70px;' scope='col'>UnitPrice</th><th class='GridViewHeaderStyle' style='width:70px;'>Selling Price</th><th class='GridViewHeaderStyle' style='width:100px;' scope='col'>Purchase Tax (%)</th><th class='GridViewHeaderStyle' style='width:100px;' scope='col'>Discount (%)</th><th class='GridViewHeaderStyle' style='width:100px;' scope='col'>Sale Tax (%)</th> <th class='GridViewHeaderStyle' style='width:100px;' scope='col'>Expiry Date</th>   </tr><tbody>";
                                }
                                else {
                                    var table = "<table id='tblResult' cellspacing='0' rules='all' border='1'><tr > <th class='GridViewHeaderStyle' style='width:20px; ' scope='col'>S.No.</th><th class='GridViewHeaderStyle' style='width:100px;' scope='col'>Quantity</th> <th class='GridViewHeaderStyle' style='width:70px;'>BatchNumber</th> <th class='GridViewHeaderStyle' style='width:70px;' scope='col'>UnitPrice</th><th class='GridViewHeaderStyle' style='width:70px;'>Selling Price</th><th class='GridViewHeaderStyle' style='width:100px;' scope='col'>GSTType</th><th class='GridViewHeaderStyle' style='width:100px;' scope='col'>Discount (%)</th><th class='GridViewHeaderStyle' style='width:100px;' scope='col'>IGST(%)</th><th class='GridViewHeaderStyle' style='width:100px;' scope='col'>CGST(%)</th><th class='GridViewHeaderStyle' style='width:100px;' scope='col'>SGST/UTGST(%)</th> <th class='GridViewHeaderStyle' style='width:100px;' scope='col'>Expiry Date</th>   </tr><tbody>";
                                }
                                if ('<%=Resources.Resource.IsGSTApplicable%>' == '0') {
                                    for (var i = 0; i < Data.length; i++) {
                                        var row = "<tr>";
                                        row += "<td class='GridViewLabItemStyle' style='width:20px; '>" + (i + 1) + "</td>";
                                        row += "<td class='GridViewLabItemStyle' style='width:70px;'>" + Data[i].Qty + "</td>";
                                        row += "<td class='GridViewLabItemStyle' style='width:70px;'>" + Data[i].BatchNumber + "</td>";
                                        row += "<td class='GridViewLabItemStyle' style='width:70px;'>" + Data[i].UnitPrice + "</td>";
                                        row += "<td class='GridViewLabItemStyle' style='width:70px;'>" + Data[i].MRP + "</td>";
                                        row += "<td class='GridViewLabItemStyle' style='width:70px;'>" + Data[i].PurTaxPer + "</td>";
                                        row += "<td class='GridViewLabItemStyle' style='width:70px;'>" + Data[i].DiscPer + "</td>";
                                        row += "<td class='GridViewLabItemStyle' style='width:70px;'>" + Data[i].SaleTaxPer + "</td>";
                                        row += "<td class='GridViewLabItemStyle' style='width:100px;'>" + Data[i].MedExpiryDate + "</td>";
                                        row += "</tr>";
                                        table += row;
                                    }
                                }
                                else if ('<%=Resources.Resource.IsGSTApplicable%>' == '1') {
                                    for (var i = 0; i < Data.length; i++) {
                                        var row = "<tr>";
                                        row += "<td class='GridViewLabItemStyle' style='width:20px; '>" + (i + 1) + "</td>";
                                        row += "<td class='GridViewLabItemStyle' style='width:70px;'>" + Data[i].Qty + "</td>";
                                        row += "<td class='GridViewLabItemStyle' style='width:70px;'>" + Data[i].BatchNumber + "</td>";
                                        row += "<td class='GridViewLabItemStyle' style='width:70px;'>" + Data[i].UnitPrice + "</td>";
                                        row += "<td class='GridViewLabItemStyle' style='width:70px;'>" + Data[i].MRP + "</td>";
                                        row += "<td class='GridViewLabItemStyle' style='width:70px;'>" + Data[i].GSTType + "</td>";
                                        row += "<td class='GridViewLabItemStyle' style='width:70px;'>" + Data[i].DiscPer + "</td>";
                                        row += "<td class='GridViewLabItemStyle' style='width:70px;'>" + Data[i].IGSTPercent + "</td>";
                                        row += "<td class='GridViewLabItemStyle' style='width:70px;'>" + Data[i].CGSTPercent + "</td>";
                                        row += "<td class='GridViewLabItemStyle' style='width:70px;'>" + Data[i].SGSTPercent + "</td>";
                                        row += "<td class='GridViewLabItemStyle' style='width:100px;'>" + Data[i].MedExpiryDate + "</td>";
                                        row += "</tr>";
                                        table += row;
                                    }
                                }

                                table += "</tbody></table>";
                                $("#div_InvestigationItems").append(table);
                                $find('modalStock').show();
                                $('#lblInvmsg').text('');

                                $('#lblItemDisplay').text($('#<%=lstItem.ClientID %> option:selected').text());
                            }

                            else {
                                $('#<%=lblMsg.ClientID %>').text('No History Found');
                            }


                        },
                        error: function (xhr, status) {
                            alert("Error ");
                            window.status = status + "\r\n" + xhr.responseText;
                        }


                    });

                }
                else {

                    $('#<%=lblMsg.ClientID %>').text('Please Select Item To View History');
                    e.preventDefault();
                }
            });
            $('#imgCloseButton').click(function () {
                $("#div_InvestigationItems").empty();
            });
        });
        function viewStock() {
        }
        function pageLoad(sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if ($find("modalStock")) {
                    $find('modalStock').hide();
                }
            }
        }
        function validateItem() {
            if (($.trim($("#<%=lstItem.ClientID%> option:selected").text()) == "")) {
                $("#<%=lblMsg.ClientID%>").text('Please Select Item');
                $("#<%=lstItem.ClientID%>").focus();
                return false;
            }
            if (($.trim($("#<%=txtPrice.ClientID%>").val()) == "")) {
                $("#<%=lblMsg.ClientID%>").text('Please Enter Rate');
                $("#<%=txtPrice.ClientID%>").focus();
                return false;
            }
            if (($.trim($("#<%=txtMRP.ClientID%>").val()) == "")) {
                $("#<%=lblMsg.ClientID%>").text('Please Enter  Selling Price');
                $("#<%=txtMRP.ClientID%>").focus();
                return false;
            }

            if (($.trim($("#<%=txtQty.ClientID%>").val()) == "") || ($.trim($("#<%=txtQty.ClientID%>").val()) <= "0")) {
                $("#<%=lblMsg.ClientID%>").text('Please Enter Quantity');
                $("#<%=txtQty.ClientID%>").focus();
                return false;
            }

            if (($.trim($("#<%=cmbAprroved.ClientID%>").val()) == "0")) {
                $("#<%=lblMsg.ClientID%>").text('Please Select Approved By');
                $("#<%=cmbAprroved.ClientID%>").focus();
                return false;
            }
            if (($.trim($("#<%=txtNarration.ClientID%>").val()) == "")) {
                $("#<%=lblMsg.ClientID%>").text('Please Enter Narration');
                $("#<%=txtNarration.ClientID%>").focus();
                return false;
            }
            document.getElementById('<%=btnAddItem.ClientID%>').disabled = true;
            document.getElementById('<%=btnAddItem.ClientID%>').value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnAddItem', '');
        }
        function validateSave() {
            document.getElementById('<%=btnSave.ClientID%>').disabled = true;
            document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');
        }
        function LoadDetail() {
            var strItem = $('#<%=lstItem.ClientID %>').val();
            //alert(strItem);
            if (strItem != null) {
                $('#<%=txtIGST.ClientID %>').val(Number(strItem.split('#')[7]).toFixed(2));
                $('#<%=txtCGST.ClientID%>').val(Number(strItem.split('#')[9]).toFixed(2));
                $('#<%=txtSGST.ClientID%>').val(Number(strItem.split('#')[8]).toFixed(2));
                $('#<%=txtHSNCode.ClientID%>').val(strItem.split('#')[11]);
                $('#<%=txtTAX1.ClientID%>').val(strItem.split('#')[14]);
                if (strItem.split('#')[10] == "IGST") {
                    $('#<%=ddlPurTax.ClientID%>').val('T4');
                    $('#<%=txtCGST.ClientID %>,#<%=txtSGST.ClientID %>,#<%=lblCGST.ClientID %>,#<%=lblSGST.ClientID %>,#<%=lblUTGST.ClientID %>').hide();
                    $('#<%=txtIGST.ClientID %>,#<%=lblIGST.ClientID %>').show();
                }
                else if (strItem.split('#')[10] == "CGST&UTGST") {
                    $('#<%=ddlPurTax.ClientID%>').val('T7');
                    $('#<%=txtCGST.ClientID %>,#<%=txtSGST.ClientID %>,#<%=lblCGST.ClientID %>,#<%=lblUTGST.ClientID %>').show();
                    $('#<%=txtIGST.ClientID %>,#<%=lblIGST.ClientID %>,#<%=lblSGST.ClientID %>').hide();
                }
                else {
                    $('#<%=ddlPurTax.ClientID%>').val('T6');
                    $('#<%=txtCGST.ClientID %>,#<%=txtSGST.ClientID %>,#<%=lblCGST.ClientID %>,#<%=lblSGST.ClientID %>').show();
                    $('#<%=txtIGST.ClientID %>,#<%=lblIGST.ClientID %>,#<%=lblUTGST.ClientID %>').hide();
                }

            }
        }
        function taxChange() {
            if ($('#<%=ddlPurTax.ClientID%>').val() == "T4") {
                $('#<%=txtCGST.ClientID %>,#<%=txtSGST.ClientID %>,#<%=lblCGST.ClientID %>,#<%=lblSGST.ClientID %>,#<%=lblUTGST.ClientID %>').hide();
                $('#<%=txtIGST.ClientID %>,#<%=lblIGST.ClientID %>').show();

            }
            else if ($('#<%=ddlPurTax.ClientID%>').val() == "T7") {
                $('#<%=txtCGST.ClientID %>,#<%=txtSGST.ClientID %>,#<%=lblCGST.ClientID %>,#<%=lblUTGST.ClientID %>').show();
                $('#<%=txtIGST.ClientID %>,#<%=lblIGST.ClientID %>,#<%=lblSGST.ClientID %>').hide();
            }
            else {
                $('#<%=txtCGST.ClientID %>,#<%=txtSGST.ClientID %>,#<%=lblCGST.ClientID %>,#<%=lblSGST.ClientID %>').show();
                $('#<%=txtIGST.ClientID %>,#<%=lblIGST.ClientID %>,#<%=lblUTGST.ClientID %>').hide();
            }
            $('#txtCGST,#txtTAX1,#txtSGST,#txtIGST').val(Number('0').toFixed(2));

        }

    </script>
    <script type="text/javascript">
        var centerWiseMarkUp = [];
        $(document).ready(function () {
            getPurchaseMarkUpPercent();
        });
            function getPurchaseMarkUpPercent() {
                serverCall('../Store/Services/CommonService.asmx/GetPurchaseMarkUpPercent', {}, function (response) {
                    var responseData = JSON.parse(response);
                    centerWiseMarkUp = responseData; //assign to global variables
                });
            }

            var onRateChange = function () {
                var strItem = $('#<%=lstItem.ClientID %>').val();
                var Rate = $('#txtPrice').val();
                var Qty = $('#txtQty').val();
                var SubCatID = strItem.split('#')[1];
                var taxPer = $('#txtTAX1').val();
                var discPer = $('#txtDisc').val();

                var netAmt = (Rate * Qty) - (Rate * Qty * discPer * 0.01) + (((Rate * Qty) - (Rate * Qty * discPer * 0.01)) * taxPer * 0.01);
                var ItemID = $('#<%=lstItem.ClientID %>').val().split('#')[0];
                var itemMRP = calculateItemMRP({
                    rate: Rate,
                    quantity: Qty,
                    totalOrderAmount: Rate*Qty,
                    otherCharges: 0,
                    markUpPercent: '',
                    subCategoryID: SubCatID,
                    centerWiseMarkUp: centerWiseMarkUp,
                    netAmount: netAmt,
                    itemId:ItemID
                });
                $('#<%=txtMRP.ClientID%>').val(itemMRP.MRP);
               // $('#txtMRP').val(itemMRP.MRP);
            }

            var calculateItemMRP = function (data) {
                var rate = data.rate;
                var quantity = data.quantity;
                var totalOrderAmount = data.totalOrderAmount;
                var otherCharges = data.otherCharges;
                var markUpPercent = data.markUpPercent;
                var netAmount = data.netAmount;

                if (String.isNullOrEmpty(markUpPercent)) {
                    var filterMarkup = [];

                    var filterMarkup = data.centerWiseMarkUp.filter(function (i) { return i.ItemID == data.itemId && i.MarkUpType == "CentreWiseItemWise" });
                    if (filterMarkup.length == 0)
                        filterMarkup = data.centerWiseMarkUp.filter(function (i) { return i.ItemID == data.itemId && i.MarkUpType == "UniversalItemWise" });
                    if (filterMarkup.length == 0)
                        filterMarkup = data.centerWiseMarkUp.filter(function (i) { return i.SubCategoryID == data.subCategoryID && i.MarkUpType == "UniversalSubCategoryWise" && i.ToRate >= data.rate });

                    //for (var j = 0; j < data.centerWiseMarkUp.length; j++) {
                    //    if (data.centerWiseMarkUp[j].SubCategoryID == data.subCategoryID) {
                    //        if ((data.rate * data.quantity) <= data.centerWiseMarkUp[j].ToRate) {
                    //            filterMarkup.push(data.centerWiseMarkUp[j]);
                    //            break;
                    //        }
                    //    }
                    //}
                }


                // Below condition commented because mark up percentage related pop up not required.
              /*  if (filterMarkup.length > 0)
                    markUpPercent = filterMarkup[0].MarkUpPercentage;

                if (markUpPercent <= 0) {
                    modelAlert('Mark Up Percentage Not Found.');
                    return 0;
                } */


             //   var itemMRP = precise_round((((((rate * quantity) / totalOrderAmount) * otherCharges) + rate * markUpPercent) / quantity), 4);

                var itemMRP = precise_round((netAmount + (netAmount * markUpPercent * 0.01)) / quantity, 4);

                return { MRP: isNaN(itemMRP) ? 0 : itemMRP, markUpPercent: markUpPercent };
            }

    </script>
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Stock Adjustment(+)</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />

        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">
                                Store Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-6">
                            <asp:RadioButtonList runat="server" ID="rblStoreType" RepeatDirection="Horizontal" OnSelectedIndexChanged="rblStoreType_SelectedIndexChanged" AutoPostBack="True">
                                <asp:ListItem Value="STO00001">Medical Store</asp:ListItem>
                                <asp:ListItem Value="STO00002">General Store</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Item Code
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtCPTCodeSearch" runat="server" Width="" />
                        </div>
                        <div class="col-md-3">
                            <input id="btnView" type="button" value="View History" class="ItDoseButton" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">
                                Search&nbsp;By&nbsp;First Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFirstNameSearch" AutoCompleteType="disabled" runat="server" Width="" TabIndex="1" />
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">
                                Search By Any Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtInBetweenSearch" runat="server" AutoCompleteType="Disabled" Width="" />
                        </div>

                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">
                                Item Name 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-20">
                            <asp:ListBox ID="lstItem" runat="server" TabIndex="2"
                                Width="655px" Height="143px" onchange="LoadDetail();"></asp:ListBox>
                            <asp:Button ID="btnViewItem" runat="server" Text="View" CssClass="ItDoseButton" style="display:none;"
                                OnClick="btnView_Click" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Rate
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPrice" runat="server" AutoCompleteType="Disabled" CssClass="ItDoseTextinputNum requiredField" Width="" ClientIDMode="Static"
                                TabIndex="3" onkeypress="return checkForSecondDecimal(this,event)" MaxLength="8" onkeyup="onRateChange();"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" TargetControlID="txtPrice"
                                FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                            <asp:Label ID="lbl1" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                        </div>
                          <div class="col-md-3">
                            <label class="pull-left">
                                Quantity
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtQty" runat="server" AutoCompleteType="Disabled" CssClass="ItDoseTextinputNum requiredField" Width="" ClientIDMode="Static"
                                TabIndex="4" onkeypress="return checkForSecondDecimal(this,event)" onkeyup="validatedot();onRateChange();"
                                MaxLength="8"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender8" runat="server" TargetControlID="txtQty"
                                FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                            <asp:Label ID="Label3" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Batch No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtBatchNo" runat="server" AutoCompleteType="Disabled"
                                TabIndex="6" Width=""></asp:TextBox>
                        </div>                      
                    </div>
                    <div class="row" style="display:none">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Selling Price
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtMRP" runat="server" CssClass="ItDoseTextinputNum requiredField" TabIndex="5" Width="100px" ClientIDMode="Static"
                                onkeypress="return checkForSecondDecimal(this,event)" MaxLength="8"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" TargetControlID="txtMRP"
                                FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                            <asp:Label ID="Label4" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Tax Calculate On
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-13">
                            <asp:RadioButtonList ID="rblTaxCal" runat="server" RepeatDirection="Horizontal" ClientIDMode="Static" Style="font-size: 10px;" Enabled="false">
                                <%--<asp:ListItem Text="MRP" Value="MRP"></asp:ListItem>
                                <asp:ListItem Text="Rate" Value="Rate"></asp:ListItem>--%>
                                <asp:ListItem Text="RateAD" Value="RateAD" Selected="True"></asp:ListItem>
                              <%--  <asp:ListItem Text="Rate Rev." Value="RateRev"></asp:ListItem>
                                <asp:ListItem Text="Rate Excl." Value="RateExcl"></asp:ListItem>
                                <asp:ListItem Text="MRP Excl." Value="MRPExcl"></asp:ListItem>
                                <asp:ListItem Text="Excise Amt." Value="ExciseAmt"></asp:ListItem>--%>
                            </asp:RadioButtonList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <%if (Resources.Resource.IsGSTApplicable == "0"){ %>
                            <label class="pull-left">
                                VAT
                            </label>
                            <b class="pull-right">:</b>
                            <%}else{ %>
                            <label class="pull-left">
                                Purchase Tax (%)
                            </label>
                            <b class="pull-right">:</b>
                            <%} %>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlPurTax" runat="server" Width="" onchange="taxChange()">
                            </asp:DropDownList>
                        </div>
                        <%if (Resources.Resource.IsGSTApplicable == "1"){ %>
                        <div class="col-md-3" style="">
                            <label class="pull-left">
                                <asp:Label ID="lblIGST" runat="server" Text="IGST(%) &nbsp;"></asp:Label>
                                <asp:Label ID="lblCGST" runat="server" Text="CGST(%) &nbsp;"></asp:Label>
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5" style="">
                            <asp:TextBox ID="txtIGST" runat="server" Width="" CssClass="ItDoseTextinputNum" onlyNumber="5" decimalPlace="2" max-value="100" MaxLength="6" ClientIDMode="Static" onkeypress="return checkForSecondDecimal(this,event)" TabIndex="11"> </asp:TextBox>
                            <asp:TextBox ID="txtCGST" runat="server" Width="" CssClass="ItDoseTextinputNum" onlyNumber="5" decimalPlace="2" max-value="100" MaxLength="6" ClientIDMode="Static" onkeypress="return checkForSecondDecimal(this,event)" TabIndex="12"> </asp:TextBox>
                        </div>
                        <div class="col-md-3" style="">
                            <label class="pull-left">
                                <asp:Label ID="lblSGST" runat="server" Text="SGST(%) &nbsp;"></asp:Label>
                                <asp:Label ID="lblUTGST" runat="server" Text="UTGST(%) &nbsp;"></asp:Label>
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5" style="">
                            <asp:TextBox ID="txtSGST" runat="server" Width="" CssClass="ItDoseTextinputNum" onlyNumber="5" decimalPlace="2" max-value="100" MaxLength="6" ClientIDMode="Static" onkeypress="return checkForSecondDecimal(this,event)" onkeyup="TaxCal();" TabIndex="13"> </asp:TextBox>
                        </div>
                        <%} %>
                        <div class="col-md-3">
                            <%if (Resources.Resource.IsGSTApplicable == "0"){ %>
                            <label class="pull-left">VAT (%) </label>
                            <b class="pull-right">:</b>
                            <%} %>
                        </div>
                        <div class="col-md-5">
                            <%if (Resources.Resource.IsGSTApplicable == "0"){ %>
                            <asp:TextBox ID="txtTAX1" runat="server" TabIndex="7" CssClass="ItDoseTextinputNum"
                                onkeypress="return checkForSecondDecimal(this,event)" onkeyup="ValidateDisc();" ClientIDMode="Static"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender4" runat="server" TargetControlID="txtTAX1"
                                FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                            <%} %>
                        </div>
                    </div>
                    <div class="row">
                          <div class="col-md-3">
                            <label class="pull-left">
                                Discount (%)
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtDisc" runat="server" CssClass="ItDoseTextinputNum" onkeypress="return checkForSecondDecimal(this,event)"
                                onkeyup="ValidateDisc();onRateChange();" TabIndex="8" ClientIDMode="Static"  ></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server" TargetControlID="txtDisc"
                                FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                    
                        <div class="col-md-3">
                            <label class="pull-left">
                                HSN Code
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtHSNCode" runat="server" AutoCompleteType="Disabled" TabIndex="9"
                                Width=""></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Approved By
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList CssClass="requiredField" ID="cmbAprroved" runat="server" TabIndex="10"
                                Width="">
                            </asp:DropDownList>
                            <asp:Label ID="Label1" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Expiry Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtExpiryDate" runat="server"   TabIndex="11" Width=""></asp:TextBox>
                            <cc1:CalendarExtender ID="clcExp" runat="server" TargetControlID="txtExpiryDate"
                                Format="dd-MMM-yyyy" ClearTime="true">
                            </cc1:CalendarExtender>
                            <asp:Label ID="Label5" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                        </div>
                        <div class="col-md-8">
                          <span style="color: #0066FF"><em>(format-01-Jan-2015)</em></span>
                        </div>
                    
                        <div class="col-md-3">
                            <label class="pull-left">
                                Narration
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox  CssClass="requiredField" ID="txtNarration" runat="server" AutoCompleteType="Disabled"
                            Width="" MaxLength="150" TabIndex="12"></asp:TextBox>
                        <asp:Label ID="Label2" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                        </div>
                    </div>
                    <div class="row" style="text-align:center;">
                        <asp:Button ID="btnAddItem" runat="server" CssClass="ItDoseButton" OnClick="btnAddItem_Click"
                            TabIndex="13" Text="Add" OnClientClick="return validateItem()" />
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
            <table style="width: 100%; border-collapse: collapse">
                <tr style="display: none;">
                    <td style="text-align: right;">Sale Tax (%) :&nbsp;</td>
                    <td>
                        <asp:DropDownList ID="ddlSaleTax" runat="server" Width="72px">
                        </asp:DropDownList>
                    </td>
                    <td style="text-align: right;">&nbsp;</td>
                    <td></td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory">
            <div style="text-align: center;">
                <table style="width: 100%;">
                    <tr>
                        <td colspan="4">
                            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                                OnRowCommand="GridView1_RowCommand">
                                <Columns>
                                    <asp:TemplateField HeaderText="S.No.">
                                        <ItemTemplate>
                                            <%# Container.DataItemIndex+1 %>
                                        </ItemTemplate>
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="ItemName" HeaderText="Item Name" HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemStyle HorizontalAlign="Center" Width="300px" CssClass="GridViewItemStyle" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="MajorUnit" HeaderText="Purchase Unit" HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemStyle HorizontalAlign="Center" Width="80px" CssClass="GridViewItemStyle" />
                                    </asp:BoundField>

                                    <asp:TemplateField HeaderText="Purchase Tax(%)">
                                        <ItemTemplate>
                                            <table>
                                                <tr>
                                                    <td>
                                                        <asp:Label ID="lblTAXType" runat="server" Text='<%# Eval("PurTax") %>'></asp:Label></td>
                                                    <td>
                                                        <asp:Label ID="lblTAX" runat="server" Text='<%# Eval("TaxPer") %>'></asp:Label></td>
                                                </tr>
                                            </table>
                                        </ItemTemplate>
                                        <HeaderStyle Width="75px" CssClass="GridViewHeaderStyle" />
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Disc.(%)">
                                        <ItemTemplate>
                                            <asp:Label ID="lblDiscount" runat="server" Text='<%# Eval("Disc") %>' />
                                        </ItemTemplate>
                                        <HeaderStyle Width="40px" CssClass="GridViewHeaderStyle" />
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="BatchNo" HeaderText="Batch No." HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemStyle HorizontalAlign="Center" Width="100px" CssClass="GridViewItemStyle" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Rate" HeaderText="Rate" HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemStyle HorizontalAlign="Center" Width="100px" CssClass="GridViewItemStyle" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="quantity" HeaderText="Qty." HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemStyle HorizontalAlign="Center" Width="80px" CssClass="GridViewItemStyle" />
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderText="Amount">
                                        <ItemTemplate>
                                            <asp:Label ID="lblAmount" runat="server" Text='<%# Math.Round( Util.GetDecimal(Eval("Rate")) *Util.GetDecimal(Eval("Quantity")),2,MidpointRounding.AwayFromZero) %>' CssClass="ItDoseTextinputNum" />
                                        </ItemTemplate>
                                        <HeaderStyle Width="80px" CssClass="GridViewHeaderStyle" />
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" />
                                    </asp:TemplateField>



                                    <asp:BoundField DataField="MRP" HeaderText="Selling Price" HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemStyle HorizontalAlign="Center" Width="100px" CssClass="GridViewItemStyle" />
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderText="Net Amt.">
                                        <ItemTemplate>
                                            <asp:Label ID="lblNetAmount" runat="server" Text='<%# Eval("NetAmount") %>' CssClass="ItDoseTextinputNum" />
                                        </ItemTemplate>
                                        <HeaderStyle Width="100px" CssClass="GridViewHeaderStyle" />
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" />
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="ExpiryDate" HeaderText="Expiry Date" HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemStyle HorizontalAlign="Center" Width="150px" CssClass="GridViewItemStyle" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="SaleTax" Visible="false" HeaderText="Sale Tax" HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemStyle HorizontalAlign="Center" Width="100px" CssClass="GridViewItemStyle" />
                                    </asp:BoundField>


                                    <asp:TemplateField HeaderText="Remove" HeaderStyle-CssClass="GridViewHeaderStyle"
                                        ItemStyle-CssClass="GridViewItemStyle">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="imbRemove" runat="server" CausesValidation="false" CommandArgument='<%# Container.DataItemIndex %>'
                                                CommandName="imbRemove" ImageUrl="~/Images/Delete.gif" ToolTip="Remove Item" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton" OnClick="btnSave_Click"
                                TabIndex="13" Text="Save" Visible="False" OnClientClick="return validateSave()" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <asp:Panel ID="PnlInvestigation" runat="server" CssClass="pnlVendorItemsFilter" Style="display: none"
            Width="820px" Height="280px">
            <div class="POuter_Box_Inventory" style="width: 818px;">
                <table style="width: 100%; border-collapse: collapse">
                    <tr>
                        <td style="text-align: right" colspan="7">Press esc or click
                            <input id="imgClose" type="image" src="../../Images/Delete.gif" onclick="closePopup();"
                                style="display: none" />
                            <asp:ImageButton ID="imgCloseButton" runat="server" ClientIDMode="Static" ImageUrl="~/Images/Delete.gif" />to
                            close
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: center" colspan="7">History Of&nbsp;<asp:Label ID="lblItemDisplay" runat="server" CssClass="ItDoseLabelSp"
                            ClientIDMode="Static"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: center" colspan="7">&nbsp;<asp:Label ID="lblInvmsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="POuter_Box_Inventory" style="width: 818px; height: 218px">
                <div class="Purchaseheader">
                </div>
                <div id="div_InvestigationItems" style="overflow: auto; max-height: 200px; width: 816px">
                </div>
            </div>
        </asp:Panel>
        <asp:Button ID="Button1" runat="server" Text="Button" Style="display: none;" CssClass="ItDoseButton" />
        <cc1:ModalPopupExtender ID="modalStock" BehaviorID="modalStock" runat="server" DropShadow="true"
            TargetControlID="Button1" PopupControlID="PnlInvestigation" CancelControlID="imgCloseButton"
            RepositionMode="RepositionOnWindowResize" X="100" Y="100">
        </cc1:ModalPopupExtender>
    </div>
</asp:Content>
