<%@ Page Language="C#" AutoEventWireup="true" CodeFile="InvestigationIndent.aspx.cs"
    Inherits="Design_IPD_InvestigationIndent" EnableEventValidation="false" %>

<%@ Register Src="~/Design/Controls/StartDate.ascx" TagName="StartDate" TagPrefix="uc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Lab</title>
    <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
    <script type="text/javascript" src="../../Scripts/Search.js"></script>
    <link rel="Stylesheet" type="text/css" href="../../Scripts/chosen.css" />
    <script type="text/javascript" src="../../Scripts/chosen.jquery.js"></script>
    <style type="text/css">
        .auto-style1 {
            width: 107px;
        }
    </style>
</head>
<body style="font-size: 10pt">
    <form id="form1" runat="server">

        <script type="text/javascript">
            function validateItem() {
                if ($("#<%=lstInv.ClientID%> option:selected").text() == "") {
                    $("#<%=lblMsg.ClientID%>").text('Please Select Item');
                    $("#<%=lstInv.ClientID%>").focus();
                    return false;
                }
            }
            function RestrictDoubleEntry(btn) {
                if (Page_IsValid) {
                    btn.disabled = true;
                    btn.value = 'Submitting...';

                    __doPostBack('btnReceipt', '');
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
            function AddInvestigation(sender, evt) {
                if (evt.keyCode > 0) {
                    keyCode = evt.keyCode;
                }
                else if (typeof (evt.charCode) != "undefined") {
                    keyCode = evt.charCode;
                }
                if (keyCode == 13) {
                    document.getElementById('btnSelect').click();
                }
            }

        </script>
        <script type="text/javascript">
            function hideSelfFrame() {
                if (window.top.document.getElementById("iframePatient") != null)
                    window.top.document.getElementById("iframePatient").style.width = "0px";
                if (window.top.document.getElementById("iframePatient") != null)
                    window.top.document.getElementById("iframePatient").style.height = "0px";
                if (window.top.document.getElementById("iframePatient") != null)
                    window.top.document.getElementById("iframePatient").src = "";
                if (window.top.document.getElementById("iframePatient") != null)
                    window.top.document.getElementById("iframePatient").style.display = "none";

            }
        </script>

        <script type="text/javascript">
            function ValidateCharactercount(charlimit, cont) {
                var id = "#" + cont.id;
                if ($(id).text().length > charlimit) {
                    $(id).text($(id).text().substring(0, charlimit));
                }
            }

            var keys = [];
            var values = [];
            $(document).ready(function () {
                var options = $('#<% = lstInv.ClientID %> option');
                $.each(options, function (index, item) {
                    keys.push(item.value);
                    values.push(item.innerHTML);
                });
                $('#<% = txtFirstNameSearch.ClientID %>').keyup(function (e) {
                    searchByFirstChar(document.getElementById('<%=txtFirstNameSearch.ClientID%>'), document.getElementById('<%=txtCPTCodeSearch.ClientID%>'), document.getElementById('<%=txtInBetweenSearch.ClientID%>'), document.getElementById('<%=lstInv.ClientID%>'), document.getElementById('btnSelect'), values, keys, e)

                });
                $('#<%=txtCPTCodeSearch.ClientID %>').keyup(function (e) {
                    searchByCPTCode(document.getElementById('<%=txtFirstNameSearch.ClientID%>'), document.getElementById('<%=txtCPTCodeSearch.ClientID%>'), document.getElementById('<%=txtInBetweenSearch.ClientID%>'), document.getElementById('<%=lstInv.ClientID%>'), document.getElementById('btnSelect'), values, keys, e)

                });
                $('#<%=txtInBetweenSearch.ClientID %>').keyup(function (e) {
                    searchByInBetween(document.getElementById('<%=txtFirstNameSearch.ClientID%>'), document.getElementById('<%=txtCPTCodeSearch.ClientID%>'), document.getElementById('<%=txtInBetweenSearch.ClientID%>'), document.getElementById('<%=lstInv.ClientID%>'), document.getElementById('btnSelect'), values, keys, e)

                });


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

        </script>
        <script type="text/javascript">

            function checkForSecondDecimalQty(sender, e) {
                formatBox = document.getElementById(sender.id);
                strLen = sender.value.length;
                strVal = sender.value;
                hasDec = false;
                e = (e) ? e : (window.event) ? event : null;
                if (sender.value == "1") {
                    sender.value = sender.value.substring(0, sender.value.length - 1);
                }
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
            function checkQty(rowID) {
                if ($.trim($(rowID).val()) == 0 || $.trim($(rowID).val()) == "") {
                    $(rowID).val(1);
                }
            }
        </script>

        <div id="Pbody_box_inventory">
            <Ajax:ScriptManager ID="ScriptManager1" runat="server">
            </Ajax:ScriptManager>
            <Ajax:UpdatePanel>
                <ContentTemplate>

                    <div class="POuter_Box_Inventory" style="text-align: center;">

                        <b>IPD Investigation Requesition</b>
                        <br />
                        <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                        <div style="text-align: right">
                            <asp:HyperLink ID="HyperLink1" Visible="False" CssClass="ItDoseLinkButton" runat="server"
                                NavigateUrl="~/Design/Lab/PatientLabSearch.aspx" Target="_parent">PATIENT SEARCH</asp:HyperLink>
                        </div>

                    </div>
                    <div class="POuter_Box_Inventory">
                        <div class="row">
                            <div class="col-md-24">
                                <div class="row">
                                    <div class="col-md-4">
                                        <label class="pull-left">
                                            Category
                                        </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:DropDownList ID="ddlcategory" runat="server" ClientIDMode="Static"
                                            OnSelectedIndexChanged="ddlcategory_SelectedIndexChanged" AutoPostBack="true" CssClass="ddlsearchable">
                                        </asp:DropDownList>
                                    </div>
                                    <div class="col-md-4">
                                        <label class="pull-left">
                                            Sub-Category
                                        </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:DropDownList ID="ddlsubcategory" runat="server" ClientIDMode="Static"
                                            OnSelectedIndexChanged="ddlsubcategory_SelectedIndexChanged" AutoPostBack="true" CssClass="ddlsearchable">
                                        </asp:DropDownList>
                                    </div>
                                    <div class="col-md-5">
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-4">
                                        <label class="pull-left">
                                            Search By First Name
                                        </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:TextBox ID="txtFirstNameSearch" ClientIDMode="Static" runat="server" AutoCompleteType="Disabled" TabIndex="1"></asp:TextBox>
                                    </div>
                                    <div class="col-md-4">
                                        <label class="pull-left">
                                            Search By CPT Code
                                        </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:TextBox ID="txtCPTCodeSearch" runat="server"
                                            onkeyup="javascript:ValidateCharactercount(10,this);" TabIndex="2" />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-4">
                                        <label class="pull-left">
                                            Search By Any Name
                                        </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:TextBox ID="txtInBetweenSearch" runat="server" AutoCompleteType="Disabled" ClientIDMode="Static"
                                            onkeypress="AddInvestigation(this,event)" TabIndex="3" />
                                    </div>
                                    <div class="col-md-4">
                                        <label class="pull-left">
                                        </label>
                                        <b class="pull-right"></b>
                                    </div>
                                    <div class="col-md-4">
                                    </div>
                                    <div class="col-md-3">
                                        <label class="pull-left">
                                        </label>
                                        <b class="pull-right"></b>
                                    </div>
                                    <div class="col-md-4">
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-4">
                                    </div>
                                    <div class="col-md-11">
                                        <asp:ListBox ID="lstInv" runat="server" Width="600px" Height="165px" CssClass="ItDoseDropdownbox"
                                            TabIndex="4" ToolTip="Select Investigation" onkeypress="AddInvestigation(this,event)" />
                                    </div>

                                </div>
                                <div class="row">
                                    <div class="col-md-3">
                                        <label class="pull-left">
                                            Doctor
                                        </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:DropDownList ID="ddlDoctor" runat="server" ToolTip="Select Doctor" ClientIDMode="Static" CssClass="ddlsearchable"
                                            TabIndex="5" />
                                    </div>
                                    <div class="col-md-3">
                                        <label class="pull-left">
                                            Indent Type 
                                        </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:DropDownList ID="ddlRequestType" runat="server" ClientIDMode="Static" TabIndex="6"></asp:DropDownList>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="pull-left">
                                            Reason 
                                        </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:TextBox ID="txtReason" runat="server" CssClass="ItDoseTextinputText" MaxLength="199" TabIndex="7"></asp:TextBox>
                                    </div>

                                </div>

                            </div>
                        </div>
                    </div>
                    <div class="POuter_Box_Inventory" style="text-align: center;">
                        <asp:Button ID="btnSelect" CausesValidation="false" runat="server" CssClass="save ItDoseButton"
                            OnClick="btnSelect_Click" Text="Select" OnClientClick="return validateItem()" TabIndex="8" ToolTip="Click To Add Investigation" />

                    </div>
                    <asp:Panel ID="pnlhide" runat="server" Visible="false">
                        <div class="POuter_Box_Inventory" style="font-size: 10pt; text-align: center">
                            <div class="Purchaseheader">
                                Selected Prescription
                            </div>
                            <div class="content" style="text-align: center; overflow-y: scroll; height: 150px; width: 99%">
                                <asp:GridView ID="grdItemRate" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False"
                                    OnRowCommand="grdItemRate_RowCommand">
                                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="35px" ItemStyle-CssClass="GridViewItemStyle"
                                            HeaderStyle-CssClass="GridViewHeaderStyle">
                                            <ItemTemplate>
                                                <%# Container.DataItemIndex+1 %>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="ItemName" HeaderText="Investigation" HeaderStyle-Width="320px"
                                            ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                        <asp:BoundField DataField="Quantity" HeaderText="Quantity" HeaderStyle-Width="50px"
                                            ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                        <asp:BoundField DataField="DoctorName" HeaderText="Doctor Name" HeaderStyle-Width="150px"
                                            ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                        <asp:BoundField DataField="IndentType" HeaderText="Indent Type" HeaderStyle-Width="100px"
                                            ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />

                                        <asp:TemplateField Visible="False">
                                            <ItemTemplate>
                                                <asp:Label ID="lblDoctorID" runat="server" Text='<%# Eval("DoctorID") %>'></asp:Label>
                                                <asp:Label ID="lblItem" runat="server" Text='<%# Eval("ItemID") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderStyle-Width="15px" ItemStyle-CssClass="GridViewItemStyle"
                                            HeaderStyle-CssClass="GridViewHeaderStyle" HeaderText="Remove" ItemStyle-HorizontalAlign="Center">
                                            <ItemTemplate>
                                                <asp:ImageButton ID="imbRemove" ToolTip="Click to Remove Investigation" runat="server" ImageUrl="~/Images/Delete.gif"
                                                    CausesValidation="false" CommandArgument='<%# Container.DataItemIndex %>' CommandName="imbRemove" />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </div>
                            <div style="text-align: center;">
                                <asp:Button AccessKey="r" ID="btnReceipt" CssClass="save ItDoseButton" OnClick="btnReceipt_Click"
                                    runat="server" OnClientClick="RestrictDoubleEntry(this);"
                                    Text="Save" TabIndex="5" ToolTip="Click To Save Investigation" />
                                &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                            </div>
                        </div>
                    </asp:Panel>
                    <asp:Label ID="lblTransactionNo" runat="server" Visible="False" />
                    <asp:Label ID="lblCaseTypeID" runat="server" Visible="False" />
                    <asp:Label ID="lblReferenceCode" runat="server" Visible="False" />
                    <asp:Label ID="lblPanelID" runat="server" Visible="False" />
                    <asp:Label ID="lblPatientID" runat="server" Visible="False" />
                    <asp:Label ID="lblDoctorID" runat="server" Visible="False"></asp:Label>
                    <asp:Label ID="lblitemid" runat="server" Visible="False" />
                    <asp:Label ID="lblPatientType" runat="server" Visible="False"></asp:Label>
                    <asp:Label ID="lblRoomID" runat="server" Visible="False"></asp:Label>
                    <asp:Label ID="lblMembership" runat="server" Visible="False"></asp:Label>


                </ContentTemplate>
            </Ajax:UpdatePanel>
        </div>
    </form>
</body>
</html>
