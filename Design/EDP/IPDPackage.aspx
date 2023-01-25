<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="IPDPackage.aspx.cs" Inherits="Design_EDP_IPDPackage" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
      <script type="text/javascript" src="../../Scripts/CheckboxSearch.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            HideControl();
        });
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
        function ValidateDecimalAmt() {
            var DigitsAfterDecimal = 2;
            var val = $("#<%=txtAmount.ClientID%>").val();
            var valIndex = val.indexOf(".");
            if (valIndex > "0") {
                if (val.length - (val.indexOf(".") + 1) > DigitsAfterDecimal) {
                    alert("Please Enter Valid Amount, Only " + DigitsAfterDecimal + " Digits Are Allowed After Decimal");
                    $("#<%=txtAmount.ClientID%>").val($("#<%=txtAmount.ClientID%>").val().substring(0, ($("#<%=txtAmount.ClientID%>").val().length - 1)))
                    return false;
                }
            }
        }

        function ValidateDecimalAmtNew() {
            var DigitsAfterDecimal = 2;
            var val = $("#<%=txtAmountNew.ClientID%>").val();
            var valIndex = val.indexOf(".");
            if (valIndex > "0") {
                if (val.length - (val.indexOf(".") + 1) > DigitsAfterDecimal) {
                    alert("Please Enter Valid Amount, Only " + DigitsAfterDecimal + " Digits Are Allowed After Decimal");
                    $("#<%=txtAmountNew.ClientID%>").val($("#<%=txtAmountNew.ClientID%>").val().substring(0, ($("#<%=txtAmountNew.ClientID%>").val().length - 1)))
                    return false;
                }
            }
        }

        function ChkPackage() {

            if ($("#<%=rbtNewEdit.ClientID%> input[type=radio]:checked").next().text() == "New") {
                if ($.trim($("#<%=txtPkg.ClientID%>").val()) == "") {
                    $("#<%=lblMsg.ClientID%>").text('Please Enter Package Name');
                    $("#<%=txtPkg.ClientID%>").focus();
                    return false;
                }


            }

            else {
                if ($("#<%=ddlPackage.ClientID%>").val() == "0") {
                    $("#<%=lblMsg.ClientID%>").text('Please Select Package Name');
                    $("#<%=ddlPackage.ClientID%>").focus();
                    return false;
                }
            }


            var totalItems = $('#grdItem').find('tr:not(:first)').length;


            if (totalItems == 0) {
                modelAlert('Please Select Package Items.');
                return false;
            }



            document.getElementById('<%=butSave.ClientID%>').disabled = true;
            document.getElementById('<%=butSave.ClientID%>').value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$butSave', '');
        }

        function ChkAmt() {
            if ($("#<%=rdbflag.ClientID%> input[type=radio]:checked").next().text() == "Qty") {
                if (($.trim($("#<%=txtqty.ClientID%>").val()) == "") || ($.trim($("#<%=txtqty.ClientID%>").val()) == "0")) {
                    $("#<%=lblMsg.ClientID%>").text('Please Enter Quantity');
                    $("#<%=txtqty.ClientID%>").focus();
                    return false;
                }
            }
            else {
                if ($.trim($("#<%=txtAmt.ClientID%>").val()) == "") {
                    $("#<%=lblMsg.ClientID%>").text('Please Enter Amount');
                    $("#<%=txtAmt.ClientID%>").focus();
                    return false;
                }
            }


            var categoryID = $.trim($('#ddlCategory').val());

            if (categoryID == '-- Select Category --')
            {
                modelAlert('Please Select Category.');
                return false;
            }


            var packageType = Number($('#rbtPackageType').find('input[type=radio]:checked').val());

            if (packageType == 2) {
                 
                var totalSelectedItems = $('#chlItems input[type=checkbox]:checked').length;

                if (totalSelectedItems == 0) {

                    modelAlert('Please select Items.', function () {

                    });
                    return false;
                }

            }



        }
        function HideControl() {
            if ($("#<%=rdbflag.ClientID%> input[type=radio]:checked").next().text() == "Qty") {
                $("#<%=lblQty.ClientID%>").text('').show();
                $("#<%=txtqty.ClientID%>").val('').show();
                $("#<%=lblAmt.ClientID%>").text('').hide();
                $("#<%=txtAmt.ClientID%>").val('').hide();
            }
            else {
                $("#<%=lblQty.ClientID%>").text('').hide();
                $("#<%=txtqty.ClientID%>").val('').hide();
                $("#<%=lblAmt.ClientID%>").text('').show();
                $("#<%=txtAmt.ClientID%>").val('').show();
            }
        }

    </script>
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="toolkit" runat="server">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">


            <b>IPD Package Master<br />
            </b>
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />


        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Package Master
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <asp:Button ID="btnReport" runat="server" ClientIDMode="Static" OnClick="btnReport_Click" Text="Report" />
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rbtNewEdit" runat="server" Font-Bold="True" Font-Names="Verdana"
                                RepeatDirection="Horizontal" OnSelectedIndexChanged="rbtNewEdit_SelectedIndexChanged"
                                AutoPostBack="True" ToolTip="Select Add Or Edit To Update Package ">
                                <asp:ListItem Selected="True" Value="1">New</asp:ListItem>
                                <asp:ListItem Value="2">Edit</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Package Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlPackage" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlPackage_SelectedIndexChanged" TabIndex="2" ToolTip="Select Package" CssClass="requiredField">
                            </asp:DropDownList>
                            <asp:TextBox ID="txtPkg" runat="server" ToolTip="Enter Package Name" MaxLength="100" TabIndex="3" CssClass="requiredField"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Status
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rdbActive" runat="server" RepeatDirection="Horizontal" RepeatLayout="Flow" ToolTip="Select Active Or De-Active To Update Package">
                                <asp:ListItem Selected="True" Value="1">Active</asp:ListItem>
                                <asp:ListItem Value="0">De-Active</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Amount
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtAmount" runat="server" CssClass="ItDoseTextinputText requiredField" Font-Bold="True" TabIndex="1"
                                MaxLength="8" ToolTip="Enter Amount" onkeypress="return checkForSecondDecimal(this,event)" onkeyup="ValidateDecimalAmt();" style="text-align:right"></asp:TextBox>
                            <br />
                            <asp:TextBox ID="txtAmountNew" runat="server" CssClass="ItDoseTextinputText" Font-Bold="True"
                                MaxLength="8" Visible="False" ToolTip="Enter Amount" onkeypress="return checkForSecondDecimal(this,event)" onkeyup="ValidateDecimalAmtNew();"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Panel
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlPanel" runat="server" AutoPostBack="True" TabIndex="2" OnSelectedIndexChanged="ddlPanel_SelectedIndexChanged" ToolTip="Select Panel" CssClass="requiredField">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Schedule Charges
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlSchCharge" runat="server" AutoPostBack="True" TabIndex="3" OnSelectedIndexChanged="ddlSchCharge_SelectedIndexChanged" ToolTip="Select Schedule Charges">
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row" style="display: none;">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Validity Days 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtValidDays" runat="server" ToolTip="Enter Vaidity Days" onkeypress="return checkForSecondDecimal(this,event)" onkeyup="ValidateDecimalAmt();" CssClass="requiredField"></asp:TextBox>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Package Detail&nbsp;
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Category
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rbtPackageType" runat="server" RepeatDirection="Horizontal" AutoPostBack="True" ClientIDMode="Static"
                                OnSelectedIndexChanged="rbtPackageType_SelectedIndexChanged" RepeatLayout="Flow"
                                ToolTip="Select Package Type">
                                <asp:ListItem Selected="True" Value="1" Text="Category Wise"></asp:ListItem>
                                <asp:ListItem Value="2" Text="Item Wise"></asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Category
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlCategory" runat="server" TabIndex="4" OnSelectedIndexChanged="ddlCategory_SelectedIndexChanged" ToolTip="Select Category" AutoPostBack="true" CssClass="requiredField" ClientIDMode="Static" > 
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <asp:RadioButtonList ID="rdbflag" runat="server" RepeatDirection="Horizontal" RepeatLayout="Flow" onclick="HideControl();"
                                ToolTip="Select Quantity Or Amount  To Update Package">
                                <asp:ListItem Selected="True" Value="0">Qty</asp:ListItem>
                                <asp:ListItem Value="1">Amt</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-5">
                            <asp:Label ID="lblQty" runat="server" Text="Quantity :"></asp:Label>
                            <asp:TextBox ID="txtqty" runat="server" CssClass="ItDoseTextinputText requiredField" TabIndex="5" Width="113px" ToolTip="Enter Quantity" MaxLength="3" style="text-align:right"></asp:TextBox>

                            <asp:Label ID="lblAmt" runat="server" Text="Amount :" TabIndex="5"></asp:Label>
                            <asp:TextBox ID="txtAmt" runat="server" CssClass="ItDoseTextinputText requiredField" MaxLength="8" Style="width: 118px; display: none;" ToolTip="Enter Amount"></asp:TextBox>

                            <asp:Button ID="btnAddInv" runat="server" CssClass="ItDoseButton" TabIndex="6" Text="Add" OnClick="btnAddInv_Click" ToolTip="Click To Add" OnClientClick="return ChkAmt()" style="text-align:right" />

                        </div>
                    </div>
                    <div class="row" id="divSearch" runat="server">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Search By Item
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtSearchItem" onkeyup="SearchCheckbox(this,'#chlItems')" />
                        </div>
                        <div class="col-md-16"></div>
                    </div>

                    <div class="row" id="trchkItem" runat="server">
                        <div class="col-md-3">
                            <asp:CheckBox ID="chkItems" runat="server" Text="Items :&nbsp;" AutoPostBack="true" OnCheckedChanged="chkItems_CheckedChanged"
                                CssClass="ItDoseCheckbox" />
                        </div>
                        <div class="col-md-21">
                            <div style="overflow: scroll; height: 150px; width: 100%; text-align: left; border: solid 1px">
                                <asp:CheckBoxList ID="chlItems" runat="server" RepeatColumns="3" RepeatDirection="Horizontal" ClientIDMode="Static"
                                    CssClass="ItDoseCheckboxlist">
                                </asp:CheckBoxList>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <asp:GridView ID="grdItem" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" OnRowDataBound="grdItem_RowDataBound" ClientIDMode="Static"
                OnRowDeleting="grdItem_RowDeleting" Width="100%">
                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                <Columns>
                    <asp:TemplateField HeaderText="S.No.">
                        <ItemTemplate>
                            <%# Container.DataItemIndex+1 %>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Package Type">
                        <ItemTemplate>
                            <asp:Label ID="lblPackageType" runat="server" Text='<%# Eval("PackageType") %>' />
                            <asp:Label ID="lblPackageTypeID" runat="server" Text='<%# Eval("PackageTypeID") %>' Visible="false"></asp:Label>
                            <asp:Label ID="lblIsAmount" runat="server" Text='<%# Eval("IsAmount") %>' Visible="false"></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Category">
                        <ItemTemplate>
                            <asp:Label ID="lblCat" runat="server" Text='<%# Eval("Category") %>'></asp:Label>
                            <asp:Label ID="lblCategoryID" runat="server" Text='<%# Eval("CategoryID") %>' Visible="false"></asp:Label>
                            <asp:Label ID="lblConfigID" runat="server" Text='<%# Eval("ConfigID") %>' Visible="false"></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="ItemName">
                        <ItemTemplate>
                            <asp:Label ID="lblItemName" runat="server" Text='<%# Eval("Detail_ItemName") %>'></asp:Label>
                            <asp:Label ID="lblItemID" runat="server" Text='<%# Eval("Detail_ItemID") %>' Visible="false"></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" Width="250px" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Quantity">
                        <ItemTemplate>
                            <asp:TextBox ID="txtQty" runat="server" Text='<%# Eval("Quantity") %>' style="text-align:right"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="ftbtxtQty" runat="server" TargetControlID="txtQty" ValidChars="0987654321"></cc1:FilteredTextBoxExtender>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" Width="150px" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Amount">
                        <ItemTemplate>
                            <asp:TextBox ID="txtAmount" runat="server" Text='<%# Eval("Amount") %>' style="text-align:right"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="ftbtxtAmount" runat="server" TargetControlID="txtAmount" ValidChars=".0987654321"></cc1:FilteredTextBoxExtender>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle"  Width="150px" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:TemplateField>
                    <asp:CommandField ShowDeleteButton="True" ButtonType="Image" HeaderText="Delete" DeleteImageUrl="~/Images/Delete.gif">
                        <HeaderStyle Width="40px" CssClass="GridViewHeaderStyle" />
                        <ItemStyle CssClass="GridViewItemStyle" />
                    </asp:CommandField>
                </Columns>
            </asp:GridView>
        </div>

        <div class="POuter_Box_Inventory" style="text-align: center">

            <cc1:FilteredTextBoxExtender ID="ft1" runat="server" TargetControlID="txtAmt" FilterType="Numbers">
            </cc1:FilteredTextBoxExtender>
            <cc1:FilteredTextBoxExtender ID="ft2" runat="server" TargetControlID="txtqty" FilterType="Numbers">
            </cc1:FilteredTextBoxExtender>
            <cc1:FilteredTextBoxExtender ID="ftbAmt" runat="server" TargetControlID="txtAmount" FilterType="Numbers,Custom" ValidChars=".">
            </cc1:FilteredTextBoxExtender>
            <cc1:FilteredTextBoxExtender ID="ftbValiddays" runat="server" TargetControlID="txtValidDays" FilterType="Numbers">
            </cc1:FilteredTextBoxExtender>
            <asp:Button ValidationGroup="save" ID="butSave" runat="server" CssClass="ItDoseButton" TabIndex="7" Text="Save"
                OnClick="butSave_Click" ToolTip="Click To Save" Visible="false" OnClientClick="return ChkPackage()" />
        </div>
    </div>
</asp:Content>
