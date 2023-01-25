<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master"
    CodeFile="DirectGRNSearch_Asset.aspx.cs" Inherits="Design_Store_DirectGRNSearch_Asset" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">

        function WriteToFile(data, name) {
            try {
                alert(data);
                alert(name);
                var popup = window.open('barcode://?cmd=' + data, '_blank');
                popup.close();
            }
            catch (e) { }
        }

        $(function () {
            $('#ucFromDate').change(function () {
                ChkDate();
            });

            $('#ucToDate').change(function () {
                ChkDate();
            });
        });

        function ChkDate() {
            $.ajax({
                url: "../Common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#ucFromDate').val() + '",DateTo:"' + $('#ucToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        DisplayMsg('MM09', '<%=lblMsg.ClientID %>');
                        $('#btnSearch').attr('disabled', 'disabled');

                        $("#tbAppointment table").remove();
                    }
                    else {
                        $('#lblMsg').text('');
                        $('#btnSearch').removeAttr('disabled');
                        $('#<%=gvGRN.ClientID %>').val(null);

                    }
                }
            });
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

                if ((charCode != 46) && ((charCode < 48) || (charCode > 57))) {
                    return false;
                }
                else {
                    if ((charCode == 46) || (charCode == 110) || (charCode == 190)) {
                        for (var i = 0; i < strLen; i++) {
                            hasDec = (strVal.charAt(i) == '.');
                            if (hasDec)
                                return false;
                        }
                    }
                }
            }
            return true;
        }
    </script>
    <script type="text/javascript">

        var _oldColor;
        function SetNewColor(source) {
            _oldColor = source.style.backgroundColor;
            source.style.backgroundColor = '#00ff00';
        }
        function SetOldColor(source) {
            source.style.backgroundColor = _oldColor;
        }
        function ShowPO(GRNNo, Type) {
            window.open('DirectGRNReport.aspx?' + Type + '=' + GRNNo);
        }
    </script>

    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" EnablePageMethods="true" runat="server"
        EnableScriptGlobalization="true" EnableScriptLocalization="true">
    </cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Direct GRN Search</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Invoice No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtInvoiceNo" runat="server" Width="" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                GRN No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtGRNNo" runat="server" Width="" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Supplier Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlVendor" runat="server" Width="" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ucFromDate" runat="server" ClientIDMode="Static" Width=""> </asp:TextBox>
                            <cc1:CalendarExtender ID="fromdate" TargetControlID="ucFromDate" Format="dd-MMM-yyyy"
                                runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ucToDate" runat="server" ClientIDMode="Static" Width=""> </asp:TextBox>
                            <cc1:CalendarExtender ID="todate" TargetControlID="ucToDate" Format="dd-MMM-yyyy"
                                runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                GRN Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlGRNType" runat="server" Width="">
                                <asp:ListItem Selected="True" Text="All" Value="2" />
                                <asp:ListItem Text="Non-Posted" Value="0" />
                                <asp:ListItem Text="Posted" Value="1" />
                                <asp:ListItem Text="Rejected" Value="3" />
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Item Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlStore" runat="server" AutoPostBack="True" Width="" OnSelectedIndexChanged="ddlStore_SelectedIndexChanged" ClientIDMode="Static" />
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div style="text-align: center;">
                <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" Text="Search"
                    OnClick="btnSearch_Click" ClientIDMode="Static" />
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Result
            </div>
            <div class="" style="text-align: center;">
                <asp:GridView ID="gvGRN" runat="server" ToolTip="Double Click for Items Detail" AutoGenerateColumns="False"
                    CssClass="GridViewStyle" AllowPaging="true" PageSize="8" OnPageIndexChanging="gvGRN_PageIndexChanging"
                    OnRowDataBound="gvGRN_RowDataBound" OnRowCommand="gvGRN_RowCommand" Width="100%">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%#Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="GRN No.">
                            <ItemTemplate>
                                <b>
                                    <asp:Label ID="lblGrn" runat="server" Text='<%# Eval("BillNo").ToString()%>' ClientIDMode="Static"></asp:Label></b>
                                    <asp:Label ID="lblGRNNo" runat="server" Text='<%# Eval("GRNNo").ToString()%>' ClientIDMode="Static" style="display:none"></asp:Label></b>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Order No." Visible="false">
                            <ItemTemplate>
                                <%# Eval("AgainstPONo")%>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="135px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Invoice No.">
                            <ItemTemplate>
                                <asp:Label ID="lblInvoiceNo" runat="server" Text='<%# Eval("InvoiceNo") %>' ClientIDMode="Static"></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Challan No.">
                            <ItemTemplate>
                                <%# Eval("ChalanNo")%>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Supplier Name">
                            <ItemTemplate>
                                <asp:Label ID="lblLedgerName" runat="server" Text='<%# Eval("LedgerName") %>' ClientIDMode="Static"></asp:Label>

                                <span style="display: none;">
                                    <asp:Label ID="lblVendorId" runat="server" Text='<%# Eval("VendorId") %>' ClientIDMode="Static"></asp:Label>
                                </span>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="350px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Date">
                            <ItemTemplate>
                                <asp:Label ID="lblGRNDate" runat="server" Text='<%# Eval("GRNDate") %>' ClientIDMode="Static"></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="85px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Post Status">
                            <ItemTemplate>
                                <asp:Label ID="lblpost" runat="server" Text='<%# Util.GetString(Eval("NewPost"))%> '></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Edit">
                            <ItemTemplate>
                                <img src="../../Images/edit.png" id="EditGRN" onclick="showEditGRN(this);" style="cursor: pointer" />
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="M/S/A">
                            <ItemTemplate>
                                <img id="imgAsset" src="../../Images/Post.gif" style="cursor: pointer;" onclick="showAssetDetailModal(this)" title="Click To Oprn" visible='<%# !Util.GetBoolean(Eval("Post")) %>' />
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Accessories">
                            <ItemTemplate>
                                <img id="imgView" src="../../Images/Post.gif" style="cursor: pointer;" onclick="showAccessoriesModal(this)" title="Click To Oprn" visible='<%# !Util.GetBoolean(Eval("Post")) %>' />
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Post">
                            <ItemTemplate>
                                <asp:ImageButton ID="imbPost" runat="server" CausesValidation="false" CommandName="APost" ImageUrl="~/Images/Post.gif" CommandArgument='<%# Eval("GRNNo") %>' Visible='<%# !Util.GetBoolean(Eval("Post")) %>' />
                                <asp:Label ID="lblpostValue" runat="server" Visible="false" Text='<%# Util.GetString(Eval("Post")) %>'></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Reject">
                            <ItemTemplate>
                                <asp:ImageButton ID="imbCancel" runat="server" CausesValidation="false" CommandName="ACancel" ImageUrl="~/Images/Delete.gif" CommandArgument='<%# Eval("GRNNo") %>' Visible='<%# !Util.GetBoolean(Eval("Post")) %>' />
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Upload/View">
                            <ItemTemplate>

                                <input type="button" id="btnPopUp" value="Upload File" onclick="showGRNFileUpload(this);" style="cursor: pointer" visible='<%# Util.GetString(Eval("IsGRNUploaded")) == "1" ? Util.GetBoolean("false") : Util.GetBoolean("true")%>' />


                                <asp:ImageButton ID="imbFileUpload" runat="server" CausesValidation="false" CommandName="AViewGRNFile" ImageUrl="~/Images/view.gif" CommandArgument='<%# Eval("GRNNo") %>' Visible='<%# Util.GetString(Eval("IsGRNUploaded")) == "1" ? Util.GetBoolean("true") : Util.GetBoolean("false")%>' />

                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>


                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>
    <div style="display: none;">
        <asp:Button ID="btnHidden" runat="server" CssClass="ItDoseButton" />
    </div>
    <asp:Panel ID="Panel1" runat="server" CssClass="pnlVendorItemsFilter" Style="display: none">
        <div class="Purchaseheader" id="Div1" runat="server">
            Cancel GRN
        </div>
        <div class="content" style="margin-left: 10px">
            <table style="width: 476px">
                <tr>
                    <td style="width: 66px">GRN No. :
                    </td>
                    <td style="width: 395px">
                        <asp:Label ID="lblGRNNo" runat="server" CssClass="ItDoseLabelSp" />
                    </td>
                </tr>
                <tr>
                    <td style="width: 66px">Reason :
                    </td>
                    <td style="width: 395px">
                        <asp:TextBox ID="txtCancelReason" runat="server" Width="250px"
                            ValidationGroup="GRNCacnel" />&nbsp;<span style="color: Red; font-size: 9px;">*</span>
                        <cc1:FilteredTextBoxExtender ID="cfsreason" TargetControlID="txtCancelReason" FilterType="LowercaseLetters,UppercaseLetters" runat="server"></cc1:FilteredTextBoxExtender>
                        <asp:RequiredFieldValidator ID="rq1" runat="server" ControlToValidate="txtCancelReason"
                            ErrorMessage="Specify Cancel Reason" ValidationGroup="GRNCacnel" Text="*" Display="None" />
                    </td>
                </tr>
            </table>
        </div>
        <div class="filterOpDiv">
            <asp:Button ID="btnGRNCancel" runat="server" CssClass="ItDoseButton" Text="Reject"
                ValidationGroup="GRNCacnel" OnClick="btnGRNCancel_Click" />&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="btnItemCancel" runat="server" CssClass="ItDoseButton" Text="Cancel"
                CausesValidation="false" />&nbsp;
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mpCancel" runat="server" CancelControlID="btnItemCancel"
        DropShadow="true" TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground"
        PopupControlID="Panel1" PopupDragHandleControlID="Div1">
    </cc1:ModalPopupExtender>
    <div id="divEditGRN" class="modal fade ">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: white; width: 1325px; height: 600px">
                <div class="modal-header">
                    <button type="button" class="close" aria-hidden="true" onclick="closeEditGRN()">&times;</button>
                    <h4 class="modal-title">Update GRN Information</h4>
                </div>
                <div class="modal-body">
                    <table style="width: 100%;">
                        <tr>
                            <td align="right">Supplier :&nbsp;</td>
                            <td align="left">
                                <asp:DropDownList ID="ddlEditVender" runat="server" ClientIDMode="Static" Width="200px"></asp:DropDownList></td>
                            <td align="right">Invoice No. & Date :&nbsp;</td>
                            <td align="left">
                                <asp:TextBox ID="txtEditInvoiceNo" runat="server" MaxLength="50" ClientIDMode="Static" Width="150px"></asp:TextBox>
                                <asp:TextBox ID="txtEditInvoiceDate" runat="server" ClientIDMode="Static" Width="100px"></asp:TextBox>
                                <cc1:CalendarExtender ID="calInvoiceDate" TargetControlID="txtEditInvoiceDate" Format="dd-MMM-yyyy"
                                    runat="server">
                                </cc1:CalendarExtender>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 100%;" colspan="4">
                                <div class="Purchaseheader">
                                    GRN List Details
                                </div>
                                <asp:Panel ID="pnlGRNList" runat="server" Height="80px" Width="100%" ScrollBars="Vertical" ClientIDMode="Static">
                                    <table id="tb_GRNList" style="width: 100%; border-collapse: collapse;">
                                        <tbody></tbody>
                                    </table>
                                </asp:Panel>
                            </td>
                        </tr>
                    </table>
                    <div class="Purchaseheader">
                        Item Details
                    </div>
                    <div id="divItemDetails" style="display: none;">
                        <asp:Panel ID="pnlEditItems" runat="server" Height="350px" Width="100%" ScrollBars="Vertical" ClientIDMode="Static">
                            <table style="width: 1290px; border-collapse: collapse;" id="tb_ItemDetails" class="GridViewStyle">
                                <tr id="tb_Header">
                                    <td style="display: none;" class="GridViewHeaderStyle">StockID</td>
                                    <td style="display: none;" class="GridViewHeaderStyle">ItemID</td>
                                    <td style="width: 100px;" class="GridViewHeaderStyle">GRN No.</td>
                                    <td style="width: 240px;" class="GridViewHeaderStyle">Item Name</td>
                                    <td style="display: none;" class="GridViewHeaderStyle">Pur. Unit</td>
                                    <td style="display: none;" class="GridViewHeaderStyle">Sale Unit</td>
                                    <td style="width: 30px;" class="GridViewHeaderStyle">C.F.</td>
                                    <td style="width: 70px;" class="GridViewHeaderStyle">HSN Code</td>
                                    <td style="width: 70px;" class="GridViewHeaderStyle">Batch No.</td>
                                    <td style="width: 40px;" class="GridViewHeaderStyle">Rate</td>
                                    <td style="width: 40px;" class="GridViewHeaderStyle">MRP</td>
                                    <td style="width: 40px;" class="GridViewHeaderStyle">QTY</td>
                                    <td style="width: 80px;" class="GridViewHeaderStyle">Exp. Date</td>
                                    <td style="width: 40px;" class="GridViewHeaderStyle">Disc.(%)</td>
                                    <td style="width: 50px;" class="GridViewHeaderStyle">Spcl  Disc.(%)</td>
                                    <td style="width: 70px;" class="GridViewHeaderStyle">Deal</td>
                                    <td style="width: 70px;" class="GridViewHeaderStyle">GST Type</td>
                                    <td style="width: 40px;" class="GridViewHeaderStyle">CGST (%)</td>
                                    <td style="width: 40px;" class="GridViewHeaderStyle">SGST (%)</td>
                                    <td style="width: 40px;" class="GridViewHeaderStyle">IGST (%)</td>
                                    <td style="display: none;" class="GridViewHeaderStyle">IsPost</td>
                                    <td style="display: none;" class="GridViewHeaderStyle">OnChalan</td>
                                    <td style="width: 30px;" class="GridViewHeaderStyle">Is Free</td>
                                    <td style="width: 30px;" class="GridViewHeaderStyle">No of Qty.</td>
                                    <td style="width: 30px;" class="GridViewHeaderStyle">Barcode</td>
                                    <td style="width: 30px;" class="GridViewHeaderStyle"></td>
                                </tr>
                            </table>

                        </asp:Panel>
                        <div class="modal-footer" align="center">
                            <input type="button" id="btnAddItem" value="Add New Item" class="ItDoseButton" onclick="addNewItem()" />
                            <input type="button" id="btnSave" value="Update" class="ItDoseButton" onclick="UpdateInfo()" />
                            <input type="button" id="btnClose" value="Close" class="ItDoseButton" onclick="closeEditGRN()" />

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="divGRNFileUpload" class="modal fade ">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: white; width: 1000px; height: 250px">
                <div class="modal-header">
                    <button type="button" class="close" aria-hidden="true" onclick="closeGRNFileUpload()">&times;</button>
                    <h4 class="modal-title">GRN File Upload</h4>
                </div>
                <div class="modal-body">
                    <table style="width: 100%;">
                        <tr>
                            <td align="right">Supplier :&nbsp;</td>
                            <td align="left">
                                <span id="SpnVendorID" style="display: none;"></span>
                                <span id="SpnVendorName"></span>
                                <asp:TextBox ID="lblVendor_ID" runat="server" ClientIDMode="Static" Style="display: none;"></asp:TextBox>
                                <asp:TextBox ID="lblVendor_Name" runat="server" ClientIDMode="Static" Style="display: none;"></asp:TextBox>
                            </td>

                            <td align="right">GRN No :&nbsp;</td>
                            <td align="left">
                                <span id="SpnGRNNo"></span>
                                <span id="SpnGRNDate" style="display: none;"></span>
                                <asp:TextBox ID="lblGRN_Date" runat="server" ClientIDMode="Static" Style="display: none;"></asp:TextBox>
                                <asp:TextBox ID="lblGRN_No" runat="server" ClientIDMode="Static" Style="display: none;"></asp:TextBox>
                            </td>

                            <td align="right">Invoice No.:&nbsp;</td>
                            <td align="left">
                                <span id="SpnInvoiceNo"></span>
                                <asp:TextBox ID="lblInvoiceNo" runat="server" ClientIDMode="Static" Style="display: none;"></asp:TextBox>
                            </td>
                        </tr>

                    </table>
                    <div class="Purchaseheader">
                        Upload GRN Document
                    </div>
                    <div class="row">
                        <div class="col-md-1"></div>
                        <div class="col-md-24">
                            <div class="row">
                                <div class="col-md-3">
                                    Upload File    
                                </div>
                                <div class="col-md-1">:</div>
                                <div class="col-md-20">
                                    <input type="file" id="fileUpload" name="file" style="display: none;" />
                                    <asp:FileUpload ID="FileUpload1" runat="server" ClientIDMode="Static" />

                                </div>
                            </div>
                        </div>
                        <div class="col-md-1"></div>

                        <div class="col-md-24">
                            <div class="row">
                                <div class="col-md-3">
                                    Remark  
                                </div>
                                <div class="col-md-1">:</div>
                                <div class="col-md-20">
                                    <input type="text" id="txtRemark1" class="challandate" value="" style="width: 450px; display: none;" />
                                    <asp:TextBox ID="txtRemark" runat="server" Style="width: 450px;"></asp:TextBox>

                                </div>
                            </div>
                        </div>
                        <div class="col-md-1"></div>

                    </div>
                    <div class="row">
                        <div class="col-md-1"></div>
                        <div class="col-md-22">
                            <div class="row">
                                <div class="col-md-24">
                                    <input type="button" tabindex="4" value="Upload" class="ItDoseButton" onclick="Upload()" style="display: none;" />
                                    <asp:Button ID="btnUpload" runat="server" Text="Upload" OnClick="btnUpload_Click" />
                                    <%--OnClientClick="closeGRNFileUpload()" --%>
                                             &nbsp;
                                    <input type="button" tabindex="4" value="Cancel" class="ItDoseButton" onclick="closeGRNFileUpload()" />


                                </div>
                            </div>
                        </div>
                        <div class="col-md-1"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <script>

        function Upload() {
            debugger
            var fileUpload = document.getElementById("fileUpload");
            var regex = /^([a-zA-Z0-9\s_\\.\-:])+(.pdf)$/;
            if (regex.test(fileUpload.value.toLowerCase())) {
                if (typeof (FileReader) != "undefined") {
                    var data = new FormData();
                    var files = $("#fileUpload").get(0).files;
                    // Add the uploaded image content to the form data collection
                    if (files.length > 0) {
                        data.append("FileUpload", files[0]);
                    }
                    // Make Ajax request with the contentType = false, and procesDate = false
                    var ajaxRequest = $.ajax({
                        type: "POST",
                        url: 'Services/WebService.asmx/UploadGRNFile',
                        contentType: false,
                        processData: false,
                        data: data
                    });
                    ajaxRequest.done(function (xhr, textStatus) {
                        // Do other operation
                    });








                    //var formData = new FormData();
                    //formData.append("FileUpload", fileUpload);
                    //$.ajax({
                    //    type: 'POST',
                    //    url: 'Services/WebService.asmx/UploadGRNFile',
                    //    data: formData,
                    //    cache: false,
                    //    dataType: 'json',
                    //    processData: false, // Don't process the files
                    //    contentType: false, // Set content type to false as jQuery will tell the server its a query string request
                    //    enctype: 'multipart/form-data',
                    //    success: function (response) {
                    //        alert('succes!!');
                    //    },
                    //    error: function (error) {
                    //        alert("errror");
                    //    }
                    //});

                } else {
                    alert("This browser does not support HTML5.");
                }
            } else {
                alert("Please upload a valid Pdf file.");
            }
        }




        function showGRNFileUpload(btn) {

            var VendorId = $(btn).closest("tr").find("#lblVendorId").html();
            var LedgerName = $(btn).closest("tr").find("#lblLedgerName").html();
            var GRNNo = $(btn).closest("tr").find("#lblGRNNo").html();
            var GRNDate = $(btn).closest("tr").find("#lblGRNDate").html();
            var InvoiceNo = $(btn).closest("tr").find("#lblInvoiceNo").html();

            $("#SpnVendorID").text(VendorId);
            $("#SpnVendorName").text(LedgerName);
            $("#SpnInvoiceNo").text(InvoiceNo);
            $("#SpnGRNNo").text(GRNNo);
            $("#SpnGRNDate").text(GRNDate);

            $('#<%=lblVendor_ID.ClientID %>').val(VendorId);
            $('#<%=lblVendor_Name.ClientID %>').val(LedgerName);
            $('#<%=lblInvoiceNo.ClientID %>').val(InvoiceNo);
            $('#<%=lblGRN_No.ClientID %>').val(GRNNo);
            $('#<%=lblGRN_Date.ClientID %>').val(GRNDate);
            //$("#lblVendor_ID").text(VendorId);
            //$("#lblVendor_Name").text(LedgerName);
            //$("#lblInvoiceNo").text(InvoiceNo);
            //$("#lblGRN_No").text(GRNNo);
            //$("#lblGRN_Date").text(GRNDate);

            $('#divGRNFileUpload').showModel();
        }


        function closeGRNFileUpload() {
            //$('#tb_ItemDetails tr:not(#tb_Header)').each(function () {
            //    $(this).remove();
            //});
            //$('#tb_GRNList tbody').empty();
            //$('#divItemDetails').hide();
            $("#txtRemark").val('');
            $('#divGRNFileUpload').hide();
        }


        function showEditGRN(btn) {
            var VendorId = $(btn).closest("tr").find("#lblVendorId").html();
            var GRNNo = $(btn).closest("tr").find("#lblGRNNo").html();
            if (checkAuthority(GRNNo) == "1") {
                $('#ddlEditVender').val(VendorId);
                $.ajax({
                    url: "Services/WebService.asmx/EditGRN",
                    data: JSON.stringify({ VendorId: VendorId, GRNNo: GRNNo }),
                    type: "POST",
                    async: false,
                    dataType: "json",
                    contentType: "application/json; charset=utf-8",
                    success: function (mydata) {
                        var Data = $.parseJSON(mydata.d);
                        $('#tb_GRNList tbody').empty();
                        $('#tb_GRNList tbody').append('<tr><td class="GridViewHeaderStyle" style="width:170px;">GRN No.</td> <td class="GridViewHeaderStyle" style="width:250px;">Challan No. & Date</td> <td class="GridViewHeaderStyle" style="width:170px;">GRN No.</td> <td class="GridViewHeaderStyle" style="width:250px;">Challan No. & Date</td> <td class="GridViewHeaderStyle" style="width:170px;">GRN No.</td> <td class="GridViewHeaderStyle" style="width:250px;">Challan No. & Date</td></tr>');
                        for (var i = 0; i < Data.length; i++) {
                            if ((i % 3) == 0)
                                $('#tb_GRNList tbody').append("<tr>")

                            $('#tb_GRNList tbody').append('<td class="GridViewItemStyle"><input type="Checkbox" id="' + Data[i].LedgerTransactionNo + '" value="' + Data[i].LedgerTransactionNo + '" name="GRNList"  onchange="showItems(this)">' + Data[i].LedgerTransactionNo + '</input> </td>');
                            $('#tb_GRNList tbody').append('<td class="GridViewItemStyle"><input type="text" id="txtChalanNo_' + Data[i].LedTnxNo + '" class="chalanNo" value="' + Data[i].ChalanNo + '" style="width:135px;"/> <input type="text" id="txtChalanDate_' + Data[i].LedTnxNo + '" class="challandate" value="' + Data[i].ChalanDate + '" style="width:100px;"/></td>');
                            if ((i % 3) == 0)
                                $('#tb_GRNList tbody').append("</tr>")
                            if (Data[i].InvoiceNo != '') {
                                $('#txtEditInvoiceNo').val(Data[i].InvoiceNo);
                                $('#txtEditInvoiceDate').val(Data[i].InvoiceDate);
                            }
                            else {
                                $('#txtEditInvoiceNo,#txtEditInvoiceDate').val('');
                            }
                        }
                        $('.challandate').datepicker({
                            dateFormat: 'dd-M-yy',
                            maxDate: '+0D',
                            changeMonth: true,
                            changeYear: true
                        });
                        $('.challandate').attr('readonly', 'readonly');
                        $('#divEditGRN').showModel();


                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        var err = eval("(" + XMLHttpRequest.responseText + ")");
                        alert(err.Message)
                    },
                });
            }
            else {
                modelAlert("You are not Authorised to Edit GRN After Post");
            }

        }
        function showItems(cb) {
            var GRNNo = $(cb).val();
            var blockAddNew = 0;
            if ($(cb).prop("checked") == true) {
                $.ajax({
                    url: "Services/WebService.asmx/LoadGRNItems",
                    data: '{"GRNNo":"' + GRNNo + '"}',
                    type: "POST",
                    datatype: "JSON",
                    async: false,
                    contentType: "application/json;charset=utf-8",
                    success: function (mydata) {
                        var Data = $.parseJSON(mydata.d);
                        for (var i = 0; i < Data.length; i++) {
                            $('#tb_ItemDetails tbody').append('<tr id="' + Data[i].StockID + '"></tr>');
                            $('#' + Data[i].StockID).append('<td style="display:none;" class="GridViewItemStyle"><span id="spnStockID_' + Data[i].StockID + '">' + Data[i].StockID + '</span></td>');
                            $('#' + Data[i].StockID).append('<td style="display:none;" class="GridViewItemStyle"><span id="spnItemID_' + Data[i].StockID + '">' + Data[i].ItemID + '</span><span id="spnIsExpirable_' + Data[i].StockID + '">' + Data[i].IsExpirable + '</span><span id="spnSubCategoryID_' + Data[i].StockID + '">' + Data[i].SubCategoryID + '</span></td>');
                            $('#' + Data[i].StockID).append('<td style="width:100px;" class="GridViewItemStyle"><span id="spnGRNNo_' + Data[i].StockID + '" style="width:100px;">' + Data[i].GRNNO + '</span></td>');
                            $('#' + Data[i].StockID).append('<td style="width:240px; text-align:left;" class="GridViewItemStyle"><input type="text" id="txtNewItem_' + Data[i].StockID + '" style="width:80px;" maxlength="15" placeholder="Search New.."></input><span id="spnItemName_' + Data[i].StockID + '" ></span></td>');
                            $('#' + Data[i].StockID).append('<td style="display:none;" class="GridViewItemStyle"><span id="spnPurUnit_' + Data[i].StockID + '" style="width:70px;">' + Data[i].MajorUnit + '</span></td>');
                            $('#' + Data[i].StockID).append('<td style="display:none;" class="GridViewItemStyle"><span id="spnSaleUnit_' + Data[i].StockID + '" style="width:70px;">' + Data[i].MinorUnit + '</span></td>');
                            $('#' + Data[i].StockID).append('<td style="width:30px;" class="GridViewItemStyle"><input type="text" id="txtConFact_' + Data[i].StockID + '" value="' + Data[i].ConversionFactor + '" style="width:30px;" maxlength="4" onkeypress="return checkForSecondDecimal(this,event)"></input></td>');
                            $('#' + Data[i].StockID).append('<td style="width:70px;" class="GridViewItemStyle"><input type="text" id="txtHSNCode_' + Data[i].StockID + '" value="' + Data[i].HSNCode + '" style="width:65px;" maxlength="15"></input></td>');
                            $('#' + Data[i].StockID).append('<td style="width:70px;" class="GridViewItemStyle"><input type="text" id="txtBatchNo_' + Data[i].StockID + '" value="' + Data[i].BatchNumber + '" style="width:65px;"  maxlength="15"></input></td>');
                            $('#' + Data[i].StockID).append('<td style="width:40px;" class="GridViewItemStyle"><input type="text" id="txtRate_' + Data[i].StockID + '" value="' + Data[i].Rate + '" style="width:38px;"  maxlength="10" onkeypress="return checkForSecondDecimal(this,event);" ></input></td>');
                            $('#' + Data[i].StockID).append('<td style="width:40px;" class="GridViewItemStyle"><input type="text" id="txtMRP_' + Data[i].StockID + '" value="' + Data[i].MRP + '" style="width:38px;"  maxlength="10" class="numberonly" onkeypress="return checkForSecondDecimal(this,event);"></input></td>');
                            $('#' + Data[i].StockID).append('<td style="width:40px;" class="GridViewItemStyle"><input type="text" id="txtQTY_' + Data[i].StockID + '" value="' + Data[i].QTY + '" style="width:38px;"  maxlength="10" class="numberonly" onkeypress="return checkForSecondDecimal(this,event);"></input></td>');
                            $('#' + Data[i].StockID).append('<td style="width:80px;" class="GridViewItemStyle"><input type="text" id="txtExpDate_' + Data[i].StockID + '" value="' + Data[i].ExpDate + '" style="width:80px;"></input></td>');
                            $('#' + Data[i].StockID).append('<td style="width:50px;" class="GridViewItemStyle"><input type="text" id="txtDiscPer_' + Data[i].StockID + '" value="' + Data[i].DiscPer + '" style="width:45px;"  maxlength="7" onkeypress="return checkForSecondDecimal(this,event);"></input></td>');
                            $('#' + Data[i].StockID).append('<td style="width:50px;" class="GridViewItemStyle"><input type="text" id="txtSpclDiscPer_' + Data[i].StockID + '" value="' + Data[i].SpecialDiscPer + '" style="width:45px;"  maxlength="7" onkeypress="return checkForSecondDecimal(this,event);"></input></td>');
                            $('#' + Data[i].StockID).append('<td style="width:70px;" class="GridViewItemStyle"><input type="text" id="txtDeal1_' + Data[i].StockID + '" style="width:25px;"  maxlength="7" onkeypress="return checkForSecondDecimal(this,event);"></input>+<input type="text" id="txtDeal2_' + Data[i].StockID + '" style="width:20px;"  maxlength="7" onkeypress="return checkForSecondDecimal(this,event);"></input></td>');
                            $('#' + Data[i].StockID).append('<td style="width:70px;" class="GridViewItemStyle"><select id="ddlGSTType_' + Data[i].StockID + '" style="width:65px;" onchange="changeTaxType(this)"></select></td>');
                            $('#' + Data[i].StockID).append('<td style="width:50px;" class="GridViewItemStyle"><input type="text" id="txtCGSTPer_' + Data[i].StockID + '" value="' + Data[i].CGSTPercent + '" style="width:50px;"  maxlength="7" onkeypress="return checkForSecondDecimal(this,event);"></input></td>');
                            $('#' + Data[i].StockID).append('<td style="width:50px;" class="GridViewItemStyle"><input type="text" id="txtSGSTPer_' + Data[i].StockID + '" value="' + Data[i].SGSTPercent + '" style="width:50px;"  maxlength="7" onkeypress="return checkForSecondDecimal(this,event);"></input></td>');
                            $('#' + Data[i].StockID).append('<td style="width:50px;" class="GridViewItemStyle"><input type="text" id="txtIGSTPer_' + Data[i].StockID + '" value="' + Data[i].IGSTPercent + '" style="width:50px;"  maxlength="7" onkeypress="return checkForSecondDecimal(this,event);"></input></td>');
                            $('#' + Data[i].StockID).append('<td style="display:none;" class="GridViewItemStyle"><span id="spnIsPost_' + Data[i].StockID + '">' + Data[i].Post + '</span></td>');
                            $('#' + Data[i].StockID).append('<td style="display:none;" class="GridViewItemStyle"><span id="spnIsOnChalan_' + Data[i].StockID + '">' + Data[i].IsOnChalan + '</td>');
                            $('#' + Data[i].StockID).append('<td style="width:30px;" class="GridViewItemStyle"><input type="checkbox" id="cbIsFree_' + Data[i].StockID + '"></input></td>');
                            $('#' + Data[i].StockID).append('<td style="width:30px;" class="GridViewItemStyle"><input type="text" id="txtBarcodeQty_' + Data[i].StockID + '" width="30px" value="0"></input></td>');
                            $('#' + Data[i].StockID).append('<td style="width:30px;" class="GridViewItemStyle"><img src="../../Images/print.gif" id="btnPrintBarcodeItem_' + Data[i].StockID + '"  style="cursor: pointer" onclick="PrintBarcode(' + Data[i].StockID + ');"></td>');
                            $('#' + Data[i].StockID).append('<td style="width:30px;" class="GridViewItemStyle"><img src="../../Images/Delete.gif" id="btnRemoveItem_' + Data[i].StockID + '" onclick="RemoveItem(' + Data[i].StockID + ');" style="cursor: pointer"></td>');
                            $('#spnItemName_' + Data[i].StockID).text(Data[i].ItemName);
                            bindGSTType("#ddlGSTType_" + Data[i].StockID);
                            if (Data[i].GSTType == "IGST") {
                                $("#ddlGSTType_" + Data[i].StockID).val('T4');
                                $('#txtIGSTPer_' + Data[i].StockID).removeAttr('disabled');
                                $('#txtCGSTPer_' + Data[i].StockID + ',#txtSGSTPer_' + Data[i].StockID).attr('disabled', 'disabled');

                            }

                            else {
                                $("#ddlGSTType_" + Data[i].StockID).val('T6');
                                $('#txtIGSTPer_' + Data[i].StockID).attr('disabled', 'disabled');
                                $('#txtCGSTPer_' + Data[i].StockID + ',#txtSGSTPer_' + Data[i].StockID).removeAttr('disabled');
                            }
                            if (Data[i].isDeal != "") {
                                $('#txtDeal1_' + Data[i].StockID).val(Data[i].isDeal.split('+')[0]);
                                $('#txtDeal2_' + Data[i].StockID).val(Data[i].isDeal.split('+')[1]);

                            }
                            $('#txtExpDate_' + Data[i].StockID).datepicker({
                                dateFormat: 'dd-M-yy',
                                minDate: '+0D',
                                changeMonth: true,
                                changeYear: true
                            });


                            $('#txtExpDate_' + Data[i].StockID).attr('readonly', 'readonly');
                            if (Data[i].IsFree == "True")
                                $('#cbIsFree_' + Data[i].StockID).attr('checked', true);
                            else
                                $('#cbIsFree_' + Data[i].StockID).attr('checked', false);
                            if ($('#spnIsPost_' + Data[i].StockID).text() == "True") {
                                blockAddNew = 1;
                                // if ($('#spnIsOnChalan_' + Data[i].StockID).text() == "True") {
                                $('#txtNewItem_' + Data[i].StockID).attr('disabled', 'disabled');
                                $('#txtConFact_' + Data[i].StockID).attr('disabled', 'disabled');
                                $('#txtQTY_' + Data[i].StockID).attr('disabled', 'disabled');
                                $('#btnRemoveItem_' + Data[i].StockID).hide();

                                // }
                            }
                            $('#txtNewItem_' + Data[i].StockID).autocomplete({
                                source: function (request, response) {
                                    $ItemName = this.element[0].value;
                                    $bindItems({ ItemName: $ItemName, StoreLedgerNo: $('#ddlStore').val() }, function (responseItems) {
                                        response(responseItems)
                                    });
                                },
                                select: function (event, ui) {
                                    var rowid = $(this).closest('tr').attr('id');
                                    var label = ui.item.label;
                                    var value = ui.item.value;
                                    this.value = '';
                                    ui.item.value = ''
                                    $('#spnItemName_' + rowid).text(label);
                                    $('#spnItemID_' + rowid).text(value.split('#')[0]);
                                    $('#spnIsExpirable_' + rowid).text(value.split('#')[1]);
                                    if (value.split('#')[1] == "NO") {
                                        $('#txtExpDate_' + rowid).val('').attr('disabled', 'disabled');
                                    }
                                    else {
                                        $('#txtExpDate_' + rowid).removeAttr('disabled');

                                    }
                                    $('#spnSaleUnit_' + rowid).text(value.split('#')[2]);
                                    $('#spnPurUnit_' + rowid).text(value.split('#')[4]);
                                    $('#txtConFact_' + rowid).val(value.split('#')[3]);
                                    $('#txtHSNCode_' + rowid).val(value.split('#')[6]);
                                    if (value.split('#')[5] == "IGST") {
                                        $('#ddlGSTType_' + rowid).val("T4");
                                        $('#txtIGSTPer_' + rowid).removeAttr('disabled');
                                        $('#txtCGSTPer_' + rowid + ',#txtSGSTPer_' + rowid).attr('disabled', 'disabled');
                                    }
                                    else {
                                        $('#ddlGSTType_' + rowid).val("T6");
                                        $('#txtIGSTPer_' + rowid).attr('disabled', 'disabled');
                                        $('#txtCGSTPer_' + rowid + ',#txtSGSTPer_' + rowid).removeAttr('disabled');
                                    }
                                    $('#txtCGSTPer_' + rowid).val(value.split('#')[7]);
                                    $('#txtSGSTPer_' + rowid).val(value.split('#')[8]);
                                    $('#txtIGSTPer_' + rowid).val(value.split('#')[9]);
                                    $('#spnSubCategoryID_' + rowid).text(value.split('#')[10]);
                                },
                                close: function (el) {
                                    el.target.value = '';
                                },
                                minLength: 2
                            });

                            $bindItems = function (data, callback) {
                                serverCall('Services/WebService.asmx/GetItemList', data, function (response) {
                                    var responseData = $.map(response, function (item) {
                                        return {
                                            value: item.itemID,
                                            label: item.itemName
                                        }
                                    });
                                    callback(responseData);
                                });
                            }

                        }



                    },
                    error: function (xhr, status) {
                        $("#spnErrorMsg").text('Error occurred, Please contact administrator');
                    }
                });
            }
            else {

                $('#tb_ItemDetails tbody tr:not(#tb_Header)').each(function () {
                    var $rowid = $(this).closest("tr");
                    if ($('#spnGRNNo_' + $rowid[0].id).text() == GRNNo) {
                        $($rowid).remove();
                    }

                });
            }
            checkEmptyTable();
            if ($('input[name="GRNList"]:checked').length > 1) {
                $('#btnAddItem').hide();
            }
            else {
                if (parseFloat(blockAddNew) > 0) {
                    $('#btnAddItem').hide();
                }
                else {
                    $('#btnAddItem').show();
                }
            }

        }
        function bindGSTType(ddlId) {
            $(ddlId).empty();
            $.ajax({
                url: "Services/WebService.asmx/bindGSTType",
                data: '{}',
                type: "POST",
                datatype: "JSON",
                async: false,
                contentType: "application/json;charset=utf-8",
                success: function (mydata) {
                    var Data = $.parseJSON(mydata.d);
                    for (var i = 0; i < Data.length; i++) {
                        $(ddlId).append($("<option></option>").attr("value", Data[i].TaxID).text(Data[i].TaxName));
                    }

                },
                error: function (xhr, status) {
                    $("#spnErrorMsg").text('Error occurred, Please contact administrator');
                }
            });
        }
        function changeTaxType(ddlTax) {
            var rowid = ddlTax.id.split('_')[1];
            if ($(ddlTax).val() == "T4") {
                $('#txtIGSTPer_' + rowid).removeAttr('disabled');
                $('#txtCGSTPer_' + rowid + ',#txtSGSTPer_' + rowid).attr('disabled', 'disabled');
            }
            else {
                $('#txtIGSTPer_' + rowid).attr('disabled', 'disabled');
                $('#txtCGSTPer_' + rowid + ',#txtSGSTPer_' + rowid).removeAttr('disabled');
            }
            $('#txtCGSTPer_' + rowid + ',#txtSGSTPer_' + rowid + ',#txtIGSTPer_' + rowid).val('0.0000');
        }
        function checkEmptyTable() {
            if ($('#tb_ItemDetails tbody tr:not(#tb_Header)').length > 0) {
                $('#divItemDetails').show();
            }
            else {
                $('#divItemDetails').hide();
            }

        }
        function addNewItem() {
            $("input[name='GRNList']").each(function () {
                if ($(this).prop("checked") == true) {
                    var rowid = "new" + $('#tb_ItemDetails tbody tr:not(#tb_Header)').length + 1;
                    $('#tb_ItemDetails tbody').append('<tr id="' + rowid + '"></tr>');
                    $('#' + rowid).append('<td style="display:none;" class="GridViewItemStyle"><span id="spnStockID_' + rowid + '"></span></td>');
                    $('#' + rowid).append('<td style="display:none;" class="GridViewItemStyle"><span id="spnItemID_' + rowid + '"></span><span id="spnIsExpirable_' + rowid + '"></span><span id="spnSubCategoryID_' + rowid + '"></span></td>');
                    $('#' + rowid).append('<td style="width:100px;" class="GridViewItemStyle"><span id="spnGRNNo_' + rowid + '" style="width:100px;">' + $(this).val() + '</span></td>');
                    $('#' + rowid).append('<td style="width:240px; text-align:left;" class="GridViewItemStyle"><input type="text" id="txtNewItem_' + rowid + '" style="width:80px;" maxlength="15" placeholder="Search New.."></input><span id="spnItemName_' + rowid + '" ></span></td>');
                    $('#' + rowid).append('<td style="display:none;" class="GridViewItemStyle"><span id="spnPurUnit_' + rowid + '" style="width:70px;"></span></td>');
                    $('#' + rowid).append('<td style="display:none;" class="GridViewItemStyle"><span id="spnSaleUnit_' + rowid + '" style="width:70px;"></span></td>');
                    $('#' + rowid).append('<td style="width:30px;" class="GridViewItemStyle"><input type="text" id="txtConFact_' + rowid + '" value="1" style="width:30px;" maxlength="4" onkeypress="return checkForSecondDecimal(this,event)"></input></td>');
                    $('#' + rowid).append('<td style="width:70px;" class="GridViewItemStyle"><input type="text" id="txtHSNCode_' + rowid + '" value="" style="width:65px;" maxlength="15"></input></td>');
                    $('#' + rowid).append('<td style="width:70px;" class="GridViewItemStyle"><input type="text" id="txtBatchNo_' + rowid + '" value="" style="width:65px;"  maxlength="15"></input></td>');
                    $('#' + rowid).append('<td style="width:40px;" class="GridViewItemStyle"><input type="text" id="txtRate_' + rowid + '" value="" style="width:38px;"  maxlength="10" onkeypress="return checkForSecondDecimal(this,event);" ></input></td>');
                    $('#' + rowid).append('<td style="width:40px;" class="GridViewItemStyle"><input type="text" id="txtMRP_' + rowid + '" value="" style="width:38px;"  maxlength="10" class="numberonly" onkeypress="return checkForSecondDecimal(this,event);"></input></td>');
                    $('#' + rowid).append('<td style="width:40px;" class="GridViewItemStyle"><input type="text" id="txtQTY_' + rowid + '" value="" style="width:38px;"  maxlength="10" class="numberonly" onkeypress="return checkForSecondDecimal(this,event);"></input></td>');
                    $('#' + rowid).append('<td style="width:80px;" class="GridViewItemStyle"><input type="text" id="txtExpDate_' + rowid + '" value="' + $.datepicker.formatDate("dd-M-yy", new Date()) + '" style="width:80px;"></input></td>');
                    $('#' + rowid).append('<td style="width:50px;" class="GridViewItemStyle"><input type="text" id="txtDiscPer_' + rowid + '" value="0.00" style="width:45px;"  maxlength="7" onkeypress="return checkForSecondDecimal(this,event);"></input></td>');
                    $('#' + rowid).append('<td style="width:50px;" class="GridViewItemStyle"><input type="text" id="txtSpclDiscPer_' + rowid + '" value="0.00" style="width:45px;"  maxlength="7" onkeypress="return checkForSecondDecimal(this,event);"></input></td>');
                    $('#' + rowid).append('<td style="width:70px;" class="GridViewItemStyle"><input type="text" id="txtDeal1_' + rowid + '" style="width:25px;"  maxlength="7" onkeypress="return checkForSecondDecimal(this,event);"></input>+<input type="text" id="txtDeal2_' + rowid + '" style="width:20px;"  maxlength="7" onkeypress="return checkForSecondDecimal(this,event);"></input></td>');
                    $('#' + rowid).append('<td style="width:70px;" class="GridViewItemStyle"><select id="ddlGSTType_' + rowid + '" style="width:65px;" onchange="changeTaxType(this)"></select></td>');
                    $('#' + rowid).append('<td style="width:50px;" class="GridViewItemStyle"><input type="text" id="txtCGSTPer_' + rowid + '" value="0.0000" style="width:50px;"  maxlength="7" onkeypress="return checkForSecondDecimal(this,event);"></input></td>');
                    $('#' + rowid).append('<td style="width:50px;" class="GridViewItemStyle"><input type="text" id="txtSGSTPer_' + rowid + '" value="0.0000" style="width:50px;"  maxlength="7" onkeypress="return checkForSecondDecimal(this,event);"></input></td>');
                    $('#' + rowid).append('<td style="width:50px;" class="GridViewItemStyle"><input type="text" id="txtIGSTPer_' + rowid + '" value="0.0000" style="width:50px;"  maxlength="7" onkeypress="return checkForSecondDecimal(this,event);"></input></td>');
                    $('#' + rowid).append('<td style="display:none;" class="GridViewItemStyle"><span id="spnIsPost_' + rowid + '">0</span></td>');
                    $('#' + rowid).append('<td style="display:none;" class="GridViewItemStyle"><span id="spnIsOnChalan_' + rowid + '">0</td>');
                    $('#' + rowid).append('<td style="width:30px;" class="GridViewItemStyle"><input type="checkbox" id="cbIsFree_' + rowid + '" ></input></td>');
                    $('#' + rowid).append('<td style="width:30px;" class="GridViewItemStyle"><input type="text" id="txtBarcodeQty_' + rowid + '"  value="0" ></input></td>');
                    $('#' + rowid).append('<td style="width:30px;" class="GridViewItemStyle"><img src="../../Images/print.gif" id="' + rowid + '"  style="cursor: pointer"></td>');
                    $('#' + rowid).append('<td style="width:30px;" class="GridViewItemStyle"><img src="../../Images/Delete.gif" id="' + rowid + '" onclick="RemoveItem(this.id);" style="cursor: pointer"></td>');
                    bindGSTType("#ddlGSTType_" + rowid);
                    $("#ddlGSTType_" + rowid).val('T6');
                    $('#txtIGSTPer_' + rowid).attr('disabled', 'disabled');
                    $('#txtCGSTPer_' + rowid + ',#txtSGSTPer_' + rowid).removeAttr('disabled');

                    $('#txtExpDate_' + rowid).datepicker({
                        dateFormat: 'dd-M-yy',
                        minDate: '+0D',
                        changeMonth: true,
                        changeYear: true
                    });
                    $('#txtExpDate_' + rowid).attr('readonly', 'readonly');
                    $('#txtNewItem_' + rowid).autocomplete({
                        source: function (request, response) {
                            $ItemName = this.element[0].value;
                            $bindItems({ ItemName: $ItemName, StoreLedgerNo: $('#ddlStore').val() }, function (responseItems) {
                                response(responseItems)
                            });
                        },
                        select: function (event, ui) {
                            var rowid = $(this).closest('tr').attr('id');
                            var label = ui.item.label;
                            var value = ui.item.value;
                            this.value = '';
                            ui.item.value = ''
                            $('#spnItemName_' + rowid).text(label);
                            $('#spnItemID_' + rowid).text(value.split('#')[0]);
                            $('#spnIsExpirable_' + rowid).text(value.split('#')[1]);
                            if (value.split('#')[1] == "NO") {
                                $('#txtExpDate_' + rowid).val('').attr('disabled', 'disabled');
                            }
                            else {
                                $('#txtExpDate_' + rowid).removeAttr('disabled');

                            }
                            $('#spnSaleUnit_' + rowid).text(value.split('#')[2]);
                            $('#spnPurUnit_' + rowid).text(value.split('#')[4]);
                            $('#txtConFact_' + rowid).val(value.split('#')[3]);
                            $('#txtHSNCode_' + rowid).val(value.split('#')[6]);
                            if (value.split('#')[5] == "IGST") {
                                $('#ddlGSTType_' + rowid).val("T4");
                                $('#txtIGSTPer_' + rowid).removeAttr('disabled');
                                $('#txtCGSTPer_' + rowid + ',#txtSGSTPer_' + rowid).attr('disabled', 'disabled');
                            }
                            else {
                                $('#ddlGSTType_' + rowid).val("T6");
                                $('#txtIGSTPer_' + rowid).attr('disabled', 'disabled');
                                $('#txtCGSTPer_' + rowid + ',#txtSGSTPer_' + rowid).removeAttr('disabled');
                            }
                            $('#txtCGSTPer_' + rowid).val(value.split('#')[7]);
                            $('#txtSGSTPer_' + rowid).val(value.split('#')[8]);
                            $('#txtIGSTPer_' + rowid).val(value.split('#')[9]);
                            $('#spnSubCategoryID_' + rowid).text(value.split('#')[10]);
                        },
                        close: function (el) {
                            el.target.value = '';
                        },
                        minLength: 2
                    });

                    $bindItems = function (data, callback) {
                        serverCall('Services/WebService.asmx/GetItemList', data, function (response) {
                            var responseData = $.map(response, function (item) {
                                return {
                                    value: item.itemID,
                                    label: item.itemName
                                }
                            });
                            callback(responseData);
                        });
                    }
                }

            });
        }
        function RemoveItem(rowId) {
            if (confirm('Are you sure to remove Item')) {
                var StockID = $('#spnStockID_' + rowId).text();
                var GRNNo = $.trim($('#spnGRNNo_' + rowId).text());
                var con = 0;
                if (StockID != "") {
                    $('#tb_ItemDetails tr:not(#tb_Header,#' + rowId + ')').each(function () {
                        var newRowId = $(this).closest('tr').attr('id');
                        if ($.trim($('#spnGRNNo_' + newRowId).text()) == GRNNo && $.trim($('#spnStockID_' + newRowId).text()) != "") {
                            con = 1;
                        }
                    });
                    if (parseFloat(con) > 0) {
                        $.ajax({
                            url: "Services/WebService.asmx/RemoveItem",
                            data: JSON.stringify({ StockID: StockID, GRNNo: GRNNo }),
                            type: "POST",
                            datatype: "JSON",
                            async: false,
                            contentType: "application/json;charset=utf-8",
                            success: function (mydata) {
                                if (mydata.d != "") {
                                    $('#' + rowId).remove();
                                }
                                else {
                                    modelAlert('Error...');
                                }

                            },
                            error: function (xhr, status) {
                                modelAlert('Error...');
                            }
                        });
                    }
                    else {

                        modelAlert('This is the single item in GRN, Please Cancel the GRN to remove it');
                    }
                }
                else {
                    $('#' + rowId).remove();
                }
                checkEmptyTable();
            }
        }
        function UpdateInfo() {
            if (validateValues() != "0") {
                var InvMaster = InvoiceMaster();
                var StockDetails = StockItems();
                $('#btnSave').attr('disabled', true);
                $.ajax({
                    url: "Services/WebService.asmx/UpdateGRNInfo",
                    data: JSON.stringify({ InvMaster: InvMaster, StockDetails: StockDetails }),
                    type: "POST",
                    datatype: "JSON",
                    async: false,
                    contentType: "application/json;charset=utf-8",
                    success: function (mydata) {
                        if (mydata.d != "") {
                            closeEditGRN();
                            modelAlert('Record Updated Successfully');

                        }
                        else {
                            modelAlert('Error...');
                        }

                    },
                    error: function (xhr, status) {
                        closeEditGRN();
                        modelAlert('Error occurred, Please contact administrator');

                    }
                });
                $('#btnSave').removeAttr('disabled');
            }


        }
        function validateValues() {
            var validate = "1";
            if ($('#txtEditInvoiceNo').val() != "" && $('#txtEditInvoiceDate').val() == "") {
                modelAlert("Please Enter Valid Invoice Date");
                $('#txtEditInvoiceDate').focus().css("border-bottom", "2px solid red");
                return "0";
            }
            $('input[name="GRNList"]:checked').each(function () {
                var GRNNo = $(this).val().replace('/', '_').replace('/', '_');
                if ($('#txtChalanNo_' + GRNNo).val() == "" && $('#txtEditInvoiceNo').val() == "") {
                    modelAlert("Please Enter Either Invoice No or Challan No.for GRN No. " + $(this).val());
                    $('#txtChalanNo_' + GRNNo).focus().css("border-bottom", "2px solid red");
                    validate = "0";
                    return false;
                }
                if ($('#txtChalanNo_' + GRNNo).val() != "" && $('#txtChalanDate_' + GRNNo).val() == "") {
                    modelAlert("Please Enter Challan Date for GRN No. " + $(this).val());
                    $('#txtChalanDate_' + GRNNo).focus().css("border-bottom", "2px solid red");
                    validate = "0";
                    return false;

                }
                var con = 0;
                $('#tb_ItemDetails tr:not(#tb_Header)').each(function () {
                    var newRowId = $(this).closest('tr').attr('id');
                    $("#" + newRowId).css("background-color", "");
                    if ($.trim($('#spnGRNNo_' + newRowId).text().replace('/', '_').replace('/', '_')) == GRNNo && $('#cbIsFree_' + newRowId).prop("checked") == false) {
                        con = 1;
                    }
                });
                if (parseFloat(con) < 1) {
                    modelAlert("There is no no-free item in GRN No. " + $(this).val() + ". Please check");
                    validate = "0";
                    return false;

                }

            });
            if (validate == "1") {
                $('#tb_ItemDetails tr:not(#tb_Header)').each(function () {
                    var rowid = $(this).closest('tr').attr('id');
                    if ($('#spnItemID_' + rowid).text() == "") {
                        modelAlert("Please Select Any  Item");
                        $('#txtNewItem_' + rowid).focus().css("border-bottom", "2px solid red");
                        validate = "0";
                        return false;

                    }
                    if ($('#txtConFact_' + rowid).val() == "") {
                        modelAlert("Please Enter Conversion Factor");
                        $('#txtConFact_' + rowid).focus().css("border-bottom", "2px solid red");
                        validate = "0";
                        return false;
                    }
                    if (parseFloat($('#txtConFact_' + rowid).val()) < 1) {
                        modelAlert("Please Enter Valid Conversion Factor");
                        $('#txtConFact_' + rowid).focus().css("border-bottom", "2px solid red");
                        validate = "0";
                        return false;
                    }
                    if ($('#txtBatchNo_' + rowid).val() == "") {
                        modelAlert("Please Enter Batch No.");
                        $('#txtBatchNo_' + rowid).focus().css("border-bottom", "2px solid red");
                        validate = "0";
                        return false;

                    }
                    if ($('#txtRate_' + rowid).val() == "" || parseFloat($('#txtRate_' + rowid).val()) < 0) {
                        modelAlert("Please Enter Valid Rate");
                        $('#txtRate_' + rowid).focus().css("border-bottom", "2px solid red");
                        validate = "0";
                        return false;

                    }
                    if ($('#txtMRP_' + rowid).val() == "" || parseFloat($('#txtMRP_' + rowid).val()) < 1) {
                        modelAlert("Please Enter Valid MRP");
                        $('#txtMRP_' + rowid).focus().css("border-bottom", "2px solid red");
                        validate = "0";
                        return false;

                    }
                    if ($('#txtQTY_' + rowid).val() == "" || parseFloat($('#txtQTY_' + rowid).val()) < 1) {
                        modelAlert("Please Enter Valid Quantity");
                        $('#txtQTY_' + rowid).focus().css("border-bottom", "2px solid red");
                        validate = "0";
                        return false;


                    }
                    if (parseFloat($('#txtRate_' + rowid).val()) > parseFloat($('#txtMRP_' + rowid).val())) {
                        modelAlert("Rate can't be Greater than MRP");
                        $('#txtRate_' + rowid).focus().css("border-bottom", "2px solid red");
                        $('#txtMRP_' + rowid).css("border-bottom", "2px solid red");
                        validate = "0";
                        return false;

                    }
                    if (parseFloat($('#txtDiscPer_' + rowid).val()) > 100) {
                        modelAlert("Discount can't be greater than 100%");
                        $('#txtDiscPer_' + rowid).focus().css("border-bottom", "2px solid red");
                        validate = "0";
                        return false;

                    }
                    if (parseFloat($('#txtSpclDiscPer_' + rowid).val()) > 100) {
                        modelAlert("Special Disc can't be greater than 100%");
                        $('#txtSpclDiscPer_' + rowid).focus().css("border-bottom", "2px solid red");
                        validate = "0";
                        return false;

                    }

                    var totalTax = parseFloat(parseFloat($("#txtCGSTPer_" + rowid).val()) + parseFloat($("#txtSGSTPer_" + rowid).val()) + parseFloat($("#txtIGSTPer_" + rowid).val()));
                    if (totalTax > 100) {
                        modelAlert("Total Tax can't be greater than 100%");
                        $('#txtCGSTPer_' + rowid).focus().css("border-bottom", "2px solid red");
                        $('#txtSGSTPer_' + rowid).css("border-bottom", "2px solid red");
                        $('#txtIGSTPer_' + rowid).css("border-bottom", "2px solid red");
                        validate = "0";
                        return false;

                    }
                    if (checkDuplicate(rowid, $('#txtBatchNo_' + rowid).val(), $('#spnItemID_' + rowid).text(), $('#cbIsFree_' + rowid).prop("checked"), $('#spnGRNNo_' + rowid).text()) == "0") {
                        validate = "0";
                        return false;
                    }


                });
            }


            return validate;



        }
        function checkDuplicate(rowId, BatchNo, ItemID, isFree, GRNNo) {
            var dup = "1";
            $('#tb_ItemDetails tr:not(#tb_Header,#' + rowId + ')').each(function () {
                var newRowID = $(this).closest('tr').attr('id');
                if (($('#txtBatchNo_' + newRowID).val() == BatchNo) && ($('#spnItemID_' + newRowID).text() == ItemID) && ($('#cbIsFree_' + newRowID).prop("checked") == isFree) && ($('#spnGRNNo_' + newRowID).text() == GRNNo)) {
                    modelAlert("Duplicate Items Exists with Same Batch and Free Condition");
                    $("#" + rowId + ",#" + newRowID).css("background-color", "lightpink");
                    dup = "0";
                    return false;
                }


            });
            return dup;
        }
        function InvoiceMaster() {

            var data = new Array();
            $('input[name="GRNList"]:checked').each(function () {
                var GRNNo = $(this).val().replace('/', '_').replace('/', '_');
                data.push({
                    LedgerTnxNo: $(this).val(),
                    VenLedgerNo: $('#ddlEditVender').val(),
                    InvoiceNo: $('#txtEditInvoiceNo').val(),
                    InvoiceDate: $('#txtEditInvoiceDate').val(),
                    ChalanNo: $('#txtChalanNo_' + GRNNo).val(),
                    ChalanDate: $('#txtChalanDate_' + GRNNo).val()
                });

            });
            return data;
        }
        function StockItems() {
            var data = new Array();
            $('#tb_ItemDetails tr:not(#tb_Header)').each(function () {
                var rowId = $(this).closest('tr').attr('id');
                var IsExpirable = 1, IsFree = 0;
                var Deal = "";
                if ($.trim($('#spnIsExpirable_' + rowId).text()) == "NO")
                    IsExpirable = 0;
                if ($('#cbIsFree_' + rowId).prop("checked") == true)
                    IsFree = 1;
                if ($('#txtDeal1_' + rowId).val() != "" && $('#txtDeal2_' + rowId).val() != "") {
                    Deal = $('#txtDeal1_' + rowId).val() + "+" + $('#txtDeal2_' + rowId).val();
                }
                data.push({
                    StockID: $.trim($('#spnStockID_' + rowId).text()),
                    ItemID: $.trim($('#spnItemID_' + rowId).text()),
                    ItemName: $.trim($('#spnItemName_' + rowId).text()),
                    IsExpirable: IsExpirable,
                    MajorUnit: $.trim($('#spnPurUnit_' + rowId).text()),
                    MinorUnit: $.trim($('#spnSaleUnit_' + rowId).val()),
                    ConversionFactor: parseFloat($.trim($('#txtConFact_' + rowId).val())),
                    HSNCode: $.trim($('#txtHSNCode_' + rowId).val()),
                    BatchNumber: $.trim($('#txtBatchNo_' + rowId).val()),
                    Rate: parseFloat($.trim($('#txtRate_' + rowId).val())),
                    MRP: parseFloat($.trim($('#txtMRP_' + rowId).val())),
                    InitialCount: parseFloat($.trim($('#txtQTY_' + rowId).val())),
                    MedExpiryDate: $.trim($('#txtExpDate_' + rowId).val()),
                    DiscPer: parseFloat($.trim($('#txtDiscPer_' + rowId).val())),
                    SpecialDiscPer: parseFloat($.trim($('#txtSpclDiscPer_' + rowId).val())),
                    GSTType: $.trim($('#ddlGSTType_' + rowId + ' option:selected').text()),
                    CGSTPercent: parseFloat($.trim($('#txtCGSTPer_' + rowId).val())),
                    SGSTPercent: parseFloat($.trim($('#txtSGSTPer_' + rowId).val())),
                    IGSTPercent: parseFloat($.trim($('#txtIGSTPer_' + rowId).val())),
                    IsFree: IsFree,
                    LedgerTransactionNo: $.trim($('#spnGRNNo_' + rowId).text()),
                    isdeal: Deal,
                    SubCategoryID: $.trim($('#spnSubCategoryID_' + rowId).text()),
                    VenLedgerNo: $('#ddlEditVender').val()

                });
            });
            return data;
        }
        function closeEditGRN() {
            $('#tb_ItemDetails tr:not(#tb_Header)').each(function () {
                $(this).remove();
            });
            $('#tb_GRNList tbody').empty();
            $('#divItemDetails').hide();
            $('#divEditGRN').hide();
        }
        function checkAuthority(GRNNo) {
            var canEdit = "0";
            $.ajax({
                url: "Services/WebService.asmx/checkAuthority",
                data: JSON.stringify({ GRNNo: GRNNo }),
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var Data = $.parseJSON(mydata.d);
                    if (Data == "1") {
                        canEdit = "1";
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    var err = eval("(" + XMLHttpRequest.responseText + ")");
                    modelAlert(err.Message)
                },
            });
            return canEdit;
        }
        function PrintBarcode(rowId) {
            if (confirm('Are you sure to print barcode')) {
                var BarcodeId = $('#spnStockID_' + rowId).text();
                var itemname = $('#spnItemName_' + rowId).text();//.ToUpper().Substring(0, 18);
                var batchnumber = $('#txtBatchNo_' + rowId).val();//.ToUpper();
                var medExpiryDate = $('#txtExpDate_' + rowId).val();//.ToUpper();
                var PrintCount = parseInt($('#txtBarcodeQty_' + rowId).val());
                $('#txtBarcodeQty_' + rowId).val(0);
                var GRNNo = $.trim($('#spnGRNNo_' + rowId).text());
                var barcode = " " + BarcodeId + "," + itemname + "," + batchnumber + "," + medExpiryDate + "," + PrintCount + " ";
                WriteToFile(barcode, GRNNo);

                //checkEmptyTable();
            }
        }


    </script>

    <script type="text/javascript">
        var showAccessoriesModal = function (btn) {
            var GRNNo = $(btn).closest("tr").find("#lblGRNNo").html();
            $("#SpnAccessGRNNo").text(GRNNo);
            $('#divAccess').showModel();
            $('#tbAccessList tbody').empty();
            loadItemsinGRNwithSerial(GRNNo, function (ItemID) {
                loadAccessoriesMaster(function () {
                    loadtaggedAccessories(GRNNo, ItemID, function () {

                    });
                });
            });
        }
        var loadItemsinGRNwithSerial = function (GRNNo, callback) {
            ddlAccessItem = $('#ddlAccessItem');
            serverCall('Services/WebService.asmx/bindItemsinGRNwithSerial', { GRNNo: GRNNo }, function (response) {
                ddlAccessItem.bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'ItemID', textField: 'ItemName', isSearchAble: true, customAttr: ['StockID', 'SerialNo','AssetID'] });
                callback(ddlAccessItem.val());
            });
        }
        var loadAccessoriesMaster = function (callback) {
            ddlAccessoriesMaster = $('#ddlAccessoriesMaster');
            serverCall('Services/WebService.asmx/bindAccessoriesMaster', {}, function (response) {
                ddlAccessoriesMaster.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'AccessoriesName', isSearchAble: true });
                callback(ddlAccessoriesMaster.val());
            });
        }
        var loadtaggedAccessories = function (GRNNo, ItemID, Callback) {
            serverCall('Services/WebService.asmx/bindtaggesAccessories', { GRNNo: GRNNo, ItemID: ItemID,AssetID:'0' }, function (response) {
                var responseData = JSON.parse(response);
                bindDetails(responseData);
            });
            Callback(true);
        }
        var tagAccessories = function (elem) {
            var data = [];
            data.push({
                AccessoriesID: $(elem).val(),
                AccessoriesName: $(elem).find('option:selected').text(),
                ItemName: $('#ddlAccessItem option:selected').text(),
                ItemID: $('#ddlAccessItem').val(),
                AccessoriesCode: '',
                StockID: $('#ddlAccessItem option:selected').attr('StockID'),
                ItemSerialNo: $('#ddlAccessItem option:selected').attr('SerialNo'),
                AssetID: $('#ddlAccessItem option:selected').attr('AssetID'),
                BatchNo: '',
                SerialNo: '',
                Quantity: '',
                ModelNo: '',
                ManufacturerID: '0',
                LicenceNo:'',
            });
            if (data[0].ItemID == 0) {
                modelAlert('Please Select any Item', function () {
                    $('#ddlAccessItem').focus();
                });
                return false;
            }
            if (data[0].AccessoriesID == 0) {
                return false;
            }
            var isDuplicate = 0;
            //if ($('#tbAccessList tbody tr').filter(function () { return (($('#tdAccessoriesID').text().trim() == data[0].AccessoriesID) && ($('#tdAAssetID').text().trim() == data[0].AssetID)) }).length > 0) {
            //   // if ($('#tbAccessList tbody tr #tdAAssetID').filter(function () { return ($('tdAAssetID').text().trim() == data[0].AssetID) }).length > 0) {
            //            isDuplicate = 1;
            //    //}
            //}
            $('#tbAccessList tbody tr').each(function (i, row) {
                if (($(row).find('#tdAccessoriesID').text().trim() == data[0].AccessoriesID) && ($(row).find('#tdAAssetID').text().trim() == data[0].AssetID)) {
                    isDuplicate = 1;
                }
            });

            if (isDuplicate == 1) {
                modelAlert('This Item is Already Tagged with this Accessories ', function () {

                });
                return false;
            }

            bindDetails(data);

        }
        var bindDetails = function (data) {
            for (var i = 0; i < data.length; i++) {
                var j = $('#tbAccessList tbody tr').length + 1;
                var row = '<tr class="trData">';
                row += '<td id="tdsrno" class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td id="tdAItemName" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].ItemName + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><select id="ddlManufacturer"></Select> <span id="spnddlManufacturer" style="display:none"></span></td>';
                row += '<td id="tdAccessoriesName" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].AccessoriesName + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><input type="text" id="txtbatchNo"  maxlength="30"  class="requiredField" value="' + data[i].BatchNo + '"/></td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><input type="text" id="txtAlicence"  maxlength="30"  class="requiredField" value="' + data[i].LicenceNo + '"/></td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><input type="text" id="txtmodelNo"  maxlength="50" class="requiredField" value ="' + data[i].ModelNo + '"/></td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><input type="text" id="txtserialNo"  maxlength="50" class="requiredField" value ="' + data[i].SerialNo + '"/></td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><input type="text" id="txtQty"  maxlength="3" onlynumber="10" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event,function(e){ });"  class="requiredField" value = "' + data[i].Quantity + '" /></td>';
                row += '<td id="tdAccessoriesCode" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].AccessoriesCode + '</td>';
                row += '<td id="tdAccessoriesID" class="GridViewLabItemStyle" style="text-align: center;display:none">' + data[i].AccessoriesID + '</td>';
                row += '<td id="tdAItemID" class="GridViewLabItemStyle" style="text-align: center;display:none">' + data[i].ItemID + '</td>';
                row += '<td id="tdAStockID" class="GridViewLabItemStyle" style="text-align: center;display:none">' + data[i].StockID + '</td>';
                row += '<td id="tdASerialNo" class="GridViewLabItemStyle" style="text-align: center;display:none">' + data[i].ItemSerialNo + '</td>';
                row += '<td id="tdAAssetID" class="GridViewLabItemStyle" style="text-align: center;display:none">' + data[i].AssetID + '</td>';
                row += '<td id="tdManufacturerID" class="GridViewLabItemStyle" style="text-align: center;display:none">' + data[i].ManufacturerID + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img id="imgEdit" src="../../Images/Delete.gif" onclick="removeAccessories(this);" style="cursor: pointer;" title="Click To Remove" /></td>';
                row += '<td class="GridViewLabItemStyle" id="tdManufacturerID" style="width: 150px; text-align: center; display:none"></td>';
                row += '</tr>';
                $('#tbAccessList tbody').append(row);
            }
            bindManufacurer();
        }
        var bindManufacurer = function () {

            $.ajax({
                url: "Services/WebService.asmx/LoadManufacturer",
                data: '{ }',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    DepartmentData = jQuery.parseJSON(result.d);
                    if (DepartmentData.length == 0) {
                        $("[id$=ddlManufacturer]").append($("<option></option>").val("0").html("---No Data Found---"));
                    }
                    else {
                        $("[id$=ddlManufacturer]").append($("<option></option>").val("0").html(" "));
                        for (i = 0; i < DepartmentData.length; i++) {
                            $("[id$=ddlManufacturer]").append($("<option></option>").val(DepartmentData[i].ManufactureID).html(DepartmentData[i].NAME));
                        }
                        $('.trData').each(function () {
                            $(this).find('#ddlManufacturer').val($(this).find('#tdManufacturerID').html());
                            $(this).find('#spnddlManufacturer').text($(this).find('#tdManufacturerID').html());
                        });
                    }
                },
                error: function (xhr, status) {
                    $("[id$=ddlManufacturer]").prop("disabled", false);
                }
            });
        }

        var removeAccessories = function (rowID) {
            var i = rowID.parentNode.parentNode.rowIndex;
            document.getElementById("tbAccessList").deleteRow(i);
            var j = 1;
            $('#tbAccessList tbody tr').each(function () {
                $(this).find('#tdsrno').html(j);
                j++;
            });
        }
        var SaveAccessoriesTagging = function () {
            getTaggedDetails(function (data) {
                serverCall('Services/WebService.asmx/SaveAccessoriesTagging', data, function (response) {
                    var responseData = JSON.parse(response);
                    modelAlert(responseData.response, function () {
                        $('#divAccess').closeModel();
                    });
                });
            });
        }
        var getTaggedDetails = function (callback) {
            taggingAccessories = [];
            var $table = $('#tbAccessList tbody tr').clone();
            $($table).each(function (index, row) {
                taggingAccessories.push({
                    ItemID: $(row).find('#tdAItemID').text().trim(),
                    StockID: $(row).find('#tdAStockID').text().trim(),
                    AccessoriesID: $(row).find('#tdAccessoriesID').text().trim(),
                    BatchNo: $(row).find('#txtbatchNo').val().trim(),
                    SerialNo: $(row).find('#txtserialNo').val().trim(),
                    ModelNo: $(row).find('#txtmodelNo').val().trim(),
                    Quantity: $(row).find('#txtQty').val(),
                    ItemSerialNo: $(row).find('#tdAccessoriesID').text().trim(),
                    ManufacturerID: $(row).find('#ddlManufacturer').val(),
                    AssetID: $(row).find('#tdAAssetID').text().trim(),
                    LicenceNo: $(row).find('#txtAlicence').val().trim(),
                });
            });
            var Blankbatchno = taggingAccessories.filter(function (i) {
                if (String.isNullOrEmpty(i.BatchNo)) {
                    return i;
                }
            });
            var Blankmodelno = taggingAccessories.filter(function (i) {
                if (String.isNullOrEmpty(i.ModelNo)) {
                    return i;
                }
            });
            var Blankserialno = taggingAccessories.filter(function (i) {
                if (String.isNullOrEmpty(i.SerialNo)) {
                    return i;
                }
            });

            var Blankqty = taggingAccessories.filter(function (i) {
                if (String.isNullOrEmpty(i.Quantity) || Number(i.Quantity) == 0) {
                    return i;
                }
            });
            if (Blankbatchno.length > 0) {
                modelAlert('Please Enter BatchNo.');
                return false;
            }
            if (Blankmodelno.length > 0) {
                modelAlert('Please Enter ModelNo.');
                return false;
            }
            if (Blankserialno.length > 0) {
                modelAlert('Please Enter Serial No.');
                return false;
            }
            if (Blankqty.length > 0) {
                modelAlert('Please Enter Quantity.');
                return false;
            }
            callback({ taggingAccessories: taggingAccessories, GRNNo: $('#SpnAccessGRNNo').text().trim() })
        }

        var SearchbyfirstName = function (elem) {
            var ItemID = $.trim($(elem).val());
            if (ItemID != 0) {
                $('#tbAccessList tr').hide();
                $('#tbAccessList tr:first').show();
                $('#tbAccessList tr').find('#tdAItemID').filter(function () {
                    if ($(this).text().toLowerCase() == ItemID.toLowerCase())
                        return $(this);
                }).parent('tr').show();
            }
            else
                $('#tbAccessList tr').show();
        }

        var showAssetDetailModal = function (btn) {
            var GRN = $(btn).closest("tr").find("#lblGRNNo").html();
            $("#SpnAssetGRNNo").text(GRN);
            $('#divAsset').showModel();
            $('#tblAsset tbody').empty();
            loadItemsinGRN(GRN, function () {
                loadAssetSerialModelDetail(GRN, function () {


                });
            });
        }
        var loadItemsinGRN = function (GRN, callback) {
            ddlItemAsstName = $('#ddlItemAsstName');
            serverCall('Services/WebService.asmx/bindItemsinGRN', { GRNNo: GRN }, function (response) {
                ddlItemAsstName.bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'ItemID', textField: 'ItemName', isSearchAble: true });
                callback(ddlItemAsstName.val());
            });
        }

        var loadAssetSerialModelDetail = function (GRN, callback) {
            serverCall('Services/WebService.asmx/loadAssetSerialModelDetail', { GRNNo: GRN }, function (response) {
                var responseData = JSON.parse(response);
                bindAssetDetails(responseData);
            });
            callback(true);
        }
        var bindAssetDetails = function (data) {
            for (var i = 0; i < data.length; i++) {
                var j = $('#tblAsset tbody tr').length + 1;
                var row = '<tr class="trData">';
                row += '<td id="tdsrno" class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td id="tdItemName" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].ItemName + '</td>';
                row += '<td id="tdBatchNumber" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].BatchNumber + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><input type="text" id="txtlicence"  maxlength="50" value ="' + data[i].LicenceNo + '"/></td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><input type="text" id="txtmodelNo"  maxlength="50" class="requiredField" value ="' + data[i].ModelNo + '"/></td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><input type="text" id="txtserialNo"  maxlength="50" class="requiredField" value ="' + data[i].SerialNo + '"/></td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><input type="text" id="txtassetNo"  maxlength="30"  value="' + data[i].AssetNo + '" disabled="true" onchange="ValidateDuplicateAssetno(this)"/></td>';
                row += '<td class="GridViewLabItemStyle" id="tdAssetID" style="width: 150px; text-align: center; display:none">' + data[i].AssetID + '</td>';
                row += '<td class="GridViewLabItemStyle" id="tdStockID" style="width: 150px; text-align: center; display:none">' + data[i].StockID + '</td>';
                row += '<td class="GridViewLabItemStyle" id="tdItemID" style="width: 150px; text-align: center; display:none">' + data[i].ItemID + '</td>';
                row += '</tr>';
                $('#tblAsset tbody').append(row);
            }
        }

        var ValidateDuplicateAssetno = function (elem) {
            var AssetNo = $(elem).val().trim();
            var isDuplicate = 0;
            if ($('#tblAsset tbody tr #txtassetNo').filter(function () { return ($(this).val().trim() == AssetNo) }).length > 1) {
                isDuplicate = 1;
            }
            if (isDuplicate == 1) {
                modelAlert('Asset No. Can not be Duplicate', function () { $(elem).val('').focus(); });
            }
            else {
                serverCall('Services/WebService.asmx/ValidateDuplicateAssetNo', { AssetNo: AssetNo }, function (response) {
                    var responseData = JSON.parse(response);
                    if (!responseData.status) {
                        modelAlert(responseData.response, function () {
                            if ($('#tblAsset tbody tr #txtassetNo').filter(function () { return ($(this).val().trim() == AssetNo) }).length > 0) {
                                $(elem).val('').focus();
                            }
                        });
                    }
                });
            }

        }
        var SearchItemIntable = function (itemid) {
            var ItemID = itemid;
            if (ItemID != 0) {
                $('#tblAsset tr').hide();
                $('#tblAsset tr:first').show();
                $('#tblAsset tr').find('#tdItemID').filter(function () {
                    if ($(this).text().toLowerCase() == ItemID.toLowerCase())
                        return $(this);
                }).parent('tr').show();
            }
            else
                $('#tblAsset tr').show();
        }

        var SaveAssetModelSerialNo = function () {
            getAssetModelSerialDetails(function (data) {
                serverCall('Services/WebService.asmx/SaveAssetModelSerialNo', data, function (response) {
                    var responseData = JSON.parse(response);
                    modelAlert(responseData.response, function () {
                        $('#divAsset').closeModel();
                    });
                });
            });
        }
        var getAssetModelSerialDetails = function (callback) {
            modelSerial = [];
            var $table = $('#tblAsset tbody tr').clone();
            $($table).each(function (index, row) {
                modelSerial.push({
                    ItemID: $(row).find('#tdItemID').text().trim(),
                    StockID: $(row).find('#tdStockID').text().trim(),
                    AssetID: $(row).find('#tdAssetID').text().trim(),
                    AssetNo: $(row).find('#txtassetNo').val().trim(),
                    SerialNo: $(row).find('#txtserialNo').val().trim(),
                    ModelNo: $(row).find('#txtmodelNo').val().trim(),
                    LicenceNo: $(row).find('#txtlicence').val().trim(),
                });
            });
            var BlankAssetNo = modelSerial.filter(function (i) {
                if (String.isNullOrEmpty(i.AssetNo)) {
                    return i;
                }
            });
            var Blankmodelno = modelSerial.filter(function (i) {
                if (String.isNullOrEmpty(i.ModelNo)) {
                    return i;
                }
            });
            var Blankserialno = modelSerial.filter(function (i) {
                if (String.isNullOrEmpty(i.SerialNo)) {
                    return i;
                }
            });

            //if (BlankAssetNo.length > 0) {
            //    modelAlert('Please Enter AssetNo.');
            //    return false;
            //}
            if (Blankmodelno.length > 0) {
                modelAlert('Please Enter ModelNo.');
                return false;
            }
            if (Blankserialno.length > 0) {
                modelAlert('Please Enter Serial No.');
                return false;
            }
         
            callback({ modelSerial: modelSerial, GRNNo: $('#SpnAssetGRNNo').text().trim() })
        }

    </script>

    <div id="divAccess" class="modal fade ">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: white; width: 1050px; height: 480px">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divAccess" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Map Accessories with Items</h4>
                </div>
                <div class="modal-header">
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">GRN No.</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-6">
                            <span id="SpnAccessGRNNo" class="patientInfo"></span>
                        </div>
                    </div>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">Item Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <%--   <select id="ddlAccessItem" onchange="loadtaggedAccessories($('#SpnAccessGRNNo').text().trim(),this.value,function(){});"></select>--%>
                            <select id="ddlAccessItem" onchange="SearchbyfirstName(this);"></select>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">Accessories</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <select id="ddlAccessoriesMaster" onchange="tagAccessories(this);"></select>
                        </div>
                    </div>
                    <div class="row">
                        <div id="divList" style="height: 270px; max-height: 270px; overflow-x: auto">
                            <table class="FixedHeader" id="tbAccessList" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                                <thead>
                                    <tr>
                                        <th class="GridViewHeaderStyle" style="width: 30px;">SrNo</th>
                                        <th class="GridViewHeaderStyle" style="width: 200px;">ItemName</th>
                                        <th class="GridViewHeaderStyle" style="width: 100px;">Manufacturer</th>
                                        <th class="GridViewHeaderStyle" style="width: 150px;">Accessories</th>
                                        <th class="GridViewHeaderStyle" style="width: 50px;">BatchNo</th>
                                        <th class="GridViewHeaderStyle" style="width: 80px;">LicenceNo</th>
                                        <th class="GridViewHeaderStyle" style="width: 80px;">ModelNo</th>
                                        <th class="GridViewHeaderStyle" style="width: 80px;">SerialNo</th>
                                        <th class="GridViewHeaderStyle" style="width: 20px;">Qty</th>
                                        <th class="GridViewHeaderStyle" style="width: 30px;">Remove</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" onclick="SaveAccessoriesTagging()">Save</button>
                    <button type="button" data-dismiss="divAccess">Close</button>
                </div>
            </div>
        </div>
    </div>

    <div id="divAsset" class="modal fade ">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: white; width: 1050px; height: 480px">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divAsset" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">ModelNo./SerialNo./AssetNo. Entry </h4>
                </div>
                <div class="modal-header">
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">GRN No.</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-6">
                            <span id="SpnAssetGRNNo" class="patientInfo"></span>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">Item Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-6">
                            <select id="ddlItemAsstName" onchange="SearchItemIntable(this.value)"></select>
                        </div>
                    </div>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div style="height: 270px; max-height: 270px; overflow-x: auto">
                            <table class="FixedHeader" id="tblAsset" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                                <thead>
                                    <tr>
                                        <th class="GridViewHeaderStyle" style="width: 30px;">SrNo</th>
                                        <th class="GridViewHeaderStyle" style="width: 200px;">ItemName</th>
                                        <th class="GridViewHeaderStyle" style="width: 100px;">BatchNo</th>
                                        <th class="GridViewHeaderStyle" style="width: 100px;">LicenceNo</th>
                                        <th class="GridViewHeaderStyle" style="width: 80px;">ModelNo</th>
                                        <th class="GridViewHeaderStyle" style="width: 80px;">SerialNo</th>
                                        <th class="GridViewHeaderStyle" style="width: 80px;">AssetNo</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" onclick="SaveAssetModelSerialNo()">Save</button>
                    <button type="button" data-dismiss="divAsset">Close</button>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
