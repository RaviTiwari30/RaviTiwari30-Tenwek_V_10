<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PatientICDCodes.aspx.cs"
    EnableEventValidation="false" Inherits="Design_CPOE_PatientICDCodes" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>
    <%--<link href="../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />--%>
    <link rel="Stylesheet" href="../../Styles/framestyle.css" />
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <script  src="../../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript" >
        function doClick(buttonName, e) {
            //the purpose of this function is to allow the enter key to 
            //point to the correct button to click.
            var key;

            if (window.event)
                key = window.event.keyCode;     //IE
            else
                key = e.which;     //firefox

            if (key == 13 || key == 35) {
                //Get the button the user wants to have clicked
                var btn = document.getElementById(buttonName);

                if (btn != null) { //If we find the button click it
                    btn.click();
                    //  event.keyCode = 0
                }
            }
        }
        

        $(document).ready(function () {
            var MaxLength = 200;

            $('#<%=txtDiagnosisDesc.ClientID%>').bind("keypress", function (e) {
                // For Internet Explorer  
                if (window.event) {
                    keynum = e.keyCode
                }
                // For Netscape/Firefox/Opera  
                else if (e.which) {
                    keynum = e.which
                }
                keychar = String.fromCharCode(keynum)
                if (e.keyCode == 39 || keychar == "'") {
                    return false;
                }

                if ($(this).val().length >= MaxLength) {

                    if (window.event)//IE
                    {
                        e.returnValue = false;
                        return false;
                    }
                    else//Firefox
                    {
                        e.preventDefault();
                        return false;
                    }

                }
            });
        });
        function pageLoad(sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if ($find("mpe")) {
                    $find("mpe").hide();

                }
            }
        }
        function validateICD() {
            if (typeof (Page_Validators) == "undefined") return;
            var SectionCode = document.getElementById("<%=reqSectionCode.ClientID%>");
            var SectionDesc = document.getElementById("<%=reqSectionDesc.ClientID%>");
            var SubSectionCode = document.getElementById("<%=reqSubSectionCode.ClientID%>");
            var SubSectionDesc = document.getElementById("<%=reqSubSectionDesc.ClientID%>");
            var reqICDCode = document.getElementById("<%=reqICDCode.ClientID%>");
            var ICDDesc = document.getElementById("<%=reqICDDesc.ClientID%>");
            var LblName = document.getElementById("<%=lblmsgpop.ClientID%>");
            ValidatorValidate(SectionCode);
            if (!SectionCode.isvalid) {
                LblName.innerText = SectionCode.errormessage;
                return false;
            }

            ValidatorValidate(SectionDesc);
            if (!SectionDesc.isvalid) {
                LblName.innerText = SectionDesc.errormessage;
                return false;
            }
            ValidatorValidate(SubSectionCode);
            if (!SubSectionCode.isvalid) {
                LblName.innerText = SubSectionCode.errormessage;
                return false;
            }
            ValidatorValidate(SubSectionDesc);
            if (!SubSectionDesc.isvalid) {
                LblName.innerText = SubSectionDesc.errormessage;
                return false;
            }
            ValidatorValidate(reqICDCode);
            if (!reqICDCode.isvalid) {
                LblName.innerText = reqICDCode.errormessage;
                return false;
            }
            ValidatorValidate(ICDDesc);
            if (!ICDDesc.isvalid) {
                LblName.innerText = ICDDesc.errormessage;
                return false;
            }
        }
        $(document).ready(function () {
            $('#<%=txtDig.ClientID %>').bind("keyup keydown", function () {
                if ($('#<%=txtDig.ClientID %>').val().length > "0") {
                    $('#<% = txtCode.ClientID %>').val('');
                    $('#<% =btnAddICDCode.ClientID %>').attr("disabled", "disabled");
                    $('#<% =btnAddICD.ClientID %>').removeAttr("disabled");

                }
            });

            $('#<%=txtCode.ClientID %>').bind("keyup keydown", function () {
                if ($('#<%=txtCode.ClientID %>').val().length > "0") {
                    $('#<% = txtDig.ClientID %>').val('');
                    $('#<% =btnAddICD.ClientID %>').attr("disabled", "disabled");
                    $('#<% =btnAddICDCode.ClientID %>').removeAttr("disabled");
                }

            });

        });
        function RestrictDoubleEntry(btn) {
            btn.disabled = true;
            btn.value = 'Submitting...';
            __doPostBack('btnSave', '');

        }
    </script>
    <script type="text/javascript">
        $(function () {
            $('input[id$=txtDig]').click(function () {
                $(this).focus().select();
            });
        });
</script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <div id="Pbody_box_inventory" style="text-align: center">
            <Ajax:ScriptManager ID="ScriptManager1" runat="server">
            </Ajax:ScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                    <b></b><b>Patient Diagnosis Information ( with ICD Codes )</b><br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <asp:Button ID="btnNewIc" runat="server" Text="Create New ICD Code" CssClass="ItDoseButton"
                    OnClick="btnNewIcd_Click" />
            </div>
            <div class="POuter_Box_Inventory">
                <div class="content">
                    <div style="text-align: center;">
                        <asp:GridView ID="grvICDCode"  OnRowCommand="grvICDCode_RowCommand" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="false">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="35px" />
                            <Columns>
                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="Group_Code" HeaderText="Section">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Group_Desc" HeaderText="Section Desc.">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="ICD10_3_Code" HeaderText="Sub Section">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="ICD10_3_Code_Desc" HeaderText="Sub Section Desc.">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="ICD10_Code" HeaderText="ICD Code">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="WHO_Full_Desc" HeaderText="ICD Desc.">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                                </asp:BoundField>
                                
                                <asp:BoundField DataField="Comment1" HeaderText="Comments">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                                </asp:BoundField>
                                
                                <asp:BoundField DataField="AddToPatientList" HeaderText="Add To Prob List">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="Remove">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imbRemove" runat="server" CausesValidation="false" CommandArgument='<%# Eval("TransactionID")+"#"+Eval("icd_id")+"#"+Eval("ID") %>'
                                            CommandName="imbRemove" ImageUrl="~/Images/Delete.gif" ToolTip="Click to Remove" />
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="60" />
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    ICD Codes&nbsp;
                </div>
                 <div class="row">
                <div class="col-md-24">
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">
                                 Search&nbsp;By&nbsp;ICD&nbsp;Desc.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-6">
                             <asp:TextBox ID="txtDig" runat="server" autocomplete="off" TabIndex="1" Width="200px"></asp:TextBox>
                        </div>
                        <div class="col-md-2">
                            <asp:Button ID="btnAddICD" Text="Add" runat="server" CssClass="ItDoseButton"
                                OnClick="btnAddICD_Click" TabIndex="2" />
                        </div>
                          <div class="col-md-4">
                            <label class="pull-left">
                                Search&nbsp;By&nbsp;ICD&nbsp;Code
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-6">
                            <asp:TextBox ID="txtCode" runat="server"  autocomplete="off" TabIndex="3" Width="160px"></asp:TextBox>
                        </div>
                         <div class="col-md-2">
                              <asp:Button ID="btnAddICDCode" Text="Add" runat="server" CssClass="ItDoseButton"
                                OnClick="btnAddICDCode_Click" TabIndex="4" />
                            <asp:Button ID="btnSelect" runat="server" CausesValidation="false" CssClass="ItDoseButton"
                                Text="Select" OnClick="btnSelect_Click" Style="display: none" />
                        </div>
                    </div>
                    <div class="row">
                                <div class="col-md-4">
                                    <label class="pull-left">
                                        Comments
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-6">
                                     <asp:TextBox ID="txtComments" runat="server" ToolTipl="Enter Comments"  Width="200px" TabIndex="7"></asp:TextBox>
                                </div>

                            </div>
                </div>
            </div>
                <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                    <tr align="center" style="display: none">
                        <td colspan="5">
                            <div style="overflow: scroll; height: 220px; text-align: left; width: 671px;" class="border">
                                <asp:GridView ID="grvCode" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                                    TabIndex="6">
                                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="Select">
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkSelect" runat="server" />
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="35px" />
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="ICD10_3_Code" HeaderText="Sub Section">
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="ICD10_3_Code_Desc" HeaderText="Sub Section Desc.">
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="ICD10_Code" HeaderText="ICD Code">
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="WHO_Full_Desc" HeaderText="ICD Desc.">
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                                        </asp:BoundField>
                                        <asp:TemplateField Visible="False">
                                            <ItemTemplate>
                                                <asp:Label ID="lblID" runat="server" Text='<%# Eval("ID") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </div>
                            <asp:Button ID="btnAdd" runat="server" CssClass="ItDoseButton" Text="Add" ValidationGroup="doc"
                                Width="60px" OnClick="btnAdd_Click" Style="display: none" />
                        </td>
                    </tr>
                </table>
            </div>
            <asp:Panel ID="pnlHide" runat="server" Visible="false">
                <div class="POuter_Box_Inventory">
                    <div class="Purchaseheader">
                        ICD - Diagnosis Description</div>
                    <table width="100%">
                        <tr align="center">
                            <td>
                                <asp:GridView ID="grvDig" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                                    TabIndex="6" OnRowCommand="grdDig_RowCommand">
                                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="S.No.">
                                            <ItemTemplate>
                                                <%# Container.DataItemIndex+1 %>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="35px" />
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="ID" HeaderText="ID" Visible="false">
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="10px" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="ICD10_3_Code" HeaderText="Sub&nbsp;Section">
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="ICD10_3_Code_Desc" HeaderText="Sub Section Desc.">
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="340" />
                                        </asp:BoundField>
                                       <%-- <asp:BoundField DataField="ICD10_Code" HeaderText="ICD&nbsp;Code">
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                                        </asp:BoundField>--%>
                                        <asp:TemplateField HeaderText="ICD&nbsp;Code">
                                        <ItemTemplate>
                                        <asp:Label ID="lblICDCode" runat="server" Text='<%#Eval("ICD10_Code") %>'></asp:Label>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                         <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="WHO_Full_Desc" HeaderText="ICD Desc.">
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="350px" />
                                        </asp:BoundField>
                                        
                                        <asp:TemplateField HeaderText="Comment">
                                        <ItemTemplate>
                                        <asp:Label ID="lblComment1" runat="server" Text='<%#Eval("Comment1") %>'></asp:Label>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                         <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        
                                        <asp:TemplateField HeaderText="Add to prob List">
                                        <ItemTemplate>
                                    <asp:CheckBox ID="chkAddToProbList" runat="server" ClientIDMode="Static"  />
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                         <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px"  />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Remove">
                                            <ItemTemplate>
                                                <asp:ImageButton ID="imbRemove" runat="server" CausesValidation="false" CommandArgument="<%# Container.DataItemIndex %>"
                                                    CommandName="imbRemove" ImageUrl="~/Images/Delete.gif" ToolTip="Click to Remove" />
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="60" />
                                        </asp:TemplateField>
                                        <asp:TemplateField Visible="False">
                                            <ItemTemplate>
                                                <asp:Label ID="lblCodeID" runat="server" Text='<%# Eval("ID") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </td>
                        </tr>
                    </table>
                </div>
                <div style="text-align: center" class="POuter_Box_Inventory">
                    <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton" OnClick="btnSave_Click"
                        Text="Save" ValidationGroup="doc"  OnClientClick="return RestrictDoubleEntry(this)"/>
                </div>
            </asp:Panel>
        </div>
        <asp:Panel ID="Panel1" runat="server" CssClass="pnlItemsFilter" Width="680px" Style="display: none">
            <div runat="server" class="Purchaseheader">
                <b>ICD Master</b> &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp;
                &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;
                &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp;
                &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp;&nbsp; &nbsp; &nbsp; 
                &nbsp;&nbsp; &nbsp; &nbsp;<em ><span style="font-size: 7.5pt">Press esc to close</span></em>
            </div>
            <div style="text-align: center;">
                <table style="width:680px;border-collapse:collapse">
                    <tr>
                        <td colspan="4" class="ItDoseLblError">
                            <asp:Label ID="lblmsgpop" runat="server"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 150px; text-align: right;">
                            Section Code :&nbsp;
                        </td>
                        <td style="width: 225px; text-align: left;">
                            <asp:TextBox ID="txtSectionId" TabIndex="1" CssClass="requiredField" Width="95%" ToolTip="Enter Section Code" MaxLength="20"
                                runat="server"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="reqSectionCode" SetFocusOnError="true" runat="server"
                                ControlToValidate="txtSectionId" ValidationGroup="SaveICD" ErrorMessage="Enter Section Code"
                                Display="None"></asp:RequiredFieldValidator>
                        </td>
                        <td style="width: 150px; text-align: right;">
                            Section Desc. :&nbsp;
                        </td>
                        <td style="width: 225px; text-align: left;">
                            <asp:TextBox ID="txtSection" Width="95%" CssClass="requiredField" TabIndex="2" ToolTip="Enter Section Desc." MaxLength="250"
                                runat="server"></asp:TextBox>
                           
                            <asp:RequiredFieldValidator ID="reqSectionDesc" SetFocusOnError="true" runat="server"
                                ControlToValidate="txtSection" ValidationGroup="SaveICD" ErrorMessage="Enter Section Desc."
                                Display="None"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 150px; text-align: right;">
                            Sub&nbsp;Section&nbsp;Code&nbsp;:&nbsp;
                        </td>
                        <td style="width: 225px; text-align: left;">
                            <asp:TextBox ID="txtSubSectionCode" Width="95%" CssClass="requiredField" runat="server" TabIndex="3" ToolTip="Enter Sub Section Code"
                                MaxLength="20"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="reqSubSectionCode" SetFocusOnError="true" runat="server"
                                ControlToValidate="txtSubSectionCode" ValidationGroup="SaveICD" ErrorMessage="Enter Sub Section Code"
                                Display="None"></asp:RequiredFieldValidator>
                        </td>
                        <td style="width: 150px; text-align: right;">
                            Sub&nbsp;Section&nbsp;Desc.&nbsp;:&nbsp;
                        </td>
                        <td style="width: 225px; text-align: left;">
                            <asp:TextBox ID="txtSubSection" Width="95%" CssClass="requiredField" TabIndex="4" ToolTip="Enter Sub Section Desc." MaxLength="250"
                                runat="server"></asp:TextBox>
                            
                            <asp:RequiredFieldValidator ID="reqSubSectionDesc" SetFocusOnError="true" runat="server"
                                ControlToValidate="txtSubSection" ValidationGroup="SaveICD" ErrorMessage="Enter Sub Section Desc."
                                Display="None"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 150px; text-align: right;">
                            ICD Code :&nbsp;
                        </td>
                        <td style="width: 225px; text-align: left;">
                            <asp:TextBox ID="txtDiagnosisCode" Width="95%" CssClass="requiredField" TabIndex="5" ToolTip="Enter ICD Code" MaxLength="200"
                                runat="server"></asp:TextBox>
                           
                            <asp:RequiredFieldValidator ID="reqICDCode" SetFocusOnError="true" runat="server"
                                ControlToValidate="txtDiagnosisCode" ValidationGroup="SaveICD" ErrorMessage="Enter ICD Code"
                                Display="None"></asp:RequiredFieldValidator>
                        </td>
                        <td style="width: 150px; text-align: right;">
                            ICD Desc. :&nbsp;
                        </td>
                        <td style="width: 225px; text-align: left;">
                            <asp:TextBox ID="txtDiagnosisDesc" Width="95%" CssClass="requiredField" TabIndex="6" ToolTip="Enter ICD Desc." MaxLength="20"
                                runat="server"></asp:TextBox>
                            
                            <asp:RequiredFieldValidator ID="reqICDDesc" SetFocusOnError="true" runat="server"
                                ControlToValidate="txtDiagnosisDesc" ValidationGroup="SaveICD" ErrorMessage="Enter ICD Desc."
                                Display="None"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 150px; text-align: right;">
                        </td>
                        <td style="width: 225px; text-align: left;">
                        </td>
                        <td style="width: 150px; text-align: right;">
                            <asp:CheckBox ID="chkAddtoPatient" runat="server" TabIndex="7" Text="ADD To Patient"
                                Checked="true" />
                        </td>
                        <td style="width: 225px; text-align: left;">
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <asp:GridView ID="grdIcd" HeaderStyle-VerticalAlign="Top" runat="server" Visible="false"
                                CssClass="GridViewStyle" AutoGenerateColumns="false">
                                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                <Columns>
                                    <asp:TemplateField HeaderText="S.No.">
                                        <ItemTemplate>
                                            <%# Container.DataItemIndex+1 %>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="35px" />
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="ICD10_3_Code" HeaderText="Sub&nbsp;Section">
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="ICD10_3_Code_Desc" HeaderText="Sub Section Desc.">
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="340" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="ICD10_Code" HeaderText="ICD&nbsp;Code">
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="WHO_Full_Desc" HeaderText="ICD Desc.">
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="350px" />
                                    </asp:BoundField>
                                </Columns>
                            </asp:GridView>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <asp:Button ID="btnSearch" OnClientClick="return validateICD();" ValidationGroup="SaveICD"
                                runat="server" TabIndex="8" ToolTip="Click to Save" Text="Save" CssClass="ItDoseButton"
                                OnClick="btnSearch_Click" />
                            <asp:Button ID="btnSave1" runat="server" Text="Save" CssClass="ItDoseButton" OnClick="btnSave1_Click"
                                Visible="false" />
                            <asp:Button ID="btnCancel" ToolTip="Click to Cancel" TabIndex="9" runat="server"
                                Text="Cancel" CssClass="ItDoseButton" OnClick="btnCancel_Click" />
                        </td>
                    </tr>
                </table>
                <br />
            </div>
        </asp:Panel>
        <div style="display: none;">
            <asp:Button runat="server" ID="button1" /></div>
        <div style="display: none;">
            <asp:Button runat="server" ID="button2" /></div>
        <cc1:ModalPopupExtender ID="mpe" TargetControlID="btn1" DropShadow="true" BackgroundCssClass="filterPupupBackground"
            PopupDragHandleControlID="dragHandle" CancelControlID="btnCancel" runat="server"
            PopupControlID="Panel1" X="100" Y="90" BehaviorID="mpe">
        </cc1:ModalPopupExtender>
        <div style="display: none;">
            <asp:Button runat="server" ID="btn1" /></div>
    </div>
    <cc1:AutoCompleteExtender runat="server" ID="autoComplete1" TargetControlID="txtDig"
        FirstRowSelected="true" BehaviorID="AutoCompleteEx" ServicePath="~/Design/CPOE/Services/AutoCompleteICD.asmx"
        ServiceMethod="GetCompletionList" MinimumPrefixLength="2" EnableCaching="true"
        CompletionSetCount="20" CompletionInterval="1000" CompletionListCssClass="autocomplete_completionListElement"
        CompletionListItemCssClass="autocomplete_listItem" ShowOnlyCurrentWordInCompletionListItem="true"
        CompletionListHighlightedItemCssClass="autocomplete_highlightedListItem">
        <Animations>
         
                    <OnShow>
                        <Sequence>
                            <%-- Make the completion list transparent and then show it --%>
                            <OpacityAction Opacity="0" />
                            <HideAction Visible="true" />
                            
                            <%--Cache the original size of the completion list the first time
                                the animation is played and then set it to zero --%>
                            <ScriptAction Script="
                                // Cache the size and setup the initial size
                                var behavior = $find('AutoCompleteEx');
                                if (!behavior._height) {
                                    var target = behavior.get_completionList();
                                    behavior._height = target.offsetHeight - 2;
                                    target.style.height = '0px';
                                }" />
                            
                            <%-- Expand from 0px to the appropriate size while fading in --%>
                            <Parallel Duration=".4">
                                <FadeIn />
                                <Length PropertyKey="height" StartValue="0" EndValueScript="$find('AutoCompleteEx')._height" />
                            </Parallel>
                        </Sequence>
                    </OnShow>
                    <OnHide>
                        <%-- Collapse down to 0px and fade out --%>
                        <Parallel Duration=".4">
                            <FadeOut />
                            <Length PropertyKey="height" StartValueScript="$find('AutoCompleteEx')._height" EndValue="0" />
                        </Parallel>
                    </OnHide>
        </Animations>
    </cc1:AutoCompleteExtender>
    <cc1:AutoCompleteExtender runat="server" ID="AutoCompleteExtender2" TargetControlID="txtCode"
        FirstRowSelected="true" BehaviorID="AutoCompleteEx1" ServicePath="~/Design/CPOE/Services/AutoCompleteICD.asmx"
        ServiceMethod="GetCompletionListCode" MinimumPrefixLength="1" EnableCaching="true"
        CompletionSetCount="20" CompletionInterval="1000" CompletionListCssClass="autocomplete_completionListElement"
        CompletionListItemCssClass="autocomplete_listItem" ShowOnlyCurrentWordInCompletionListItem="true"
        CompletionListHighlightedItemCssClass="autocomplete_highlightedListItem">
        <Animations>
         
                    <OnShow>
                        <Sequence>
                            <%-- Make the completion list transparent and then show it --%>
                            <OpacityAction Opacity="0" />
                            <HideAction Visible="true" />
                            
                            <%--Cache the original size of the completion list the first time
                                the animation is played and then set it to zero --%>
                            <ScriptAction Script="
                                // Cache the size and setup the initial size
                                var behavior = $find('AutoCompleteEx1');
                                if (!behavior._height) {
                                    var target = behavior.get_completionList();
                                    behavior._height = target.offsetHeight - 2;
                                    target.style.height = '0px';
                                }" />
                            
                            <%-- Expand from 0px to the appropriate size while fading in --%>
                            <Parallel Duration=".4">
                                <FadeIn />
                                <Length PropertyKey="height" StartValue="0" EndValueScript="$find('AutoCompleteEx1')._height" />
                            </Parallel>
                        </Sequence>
                    </OnShow>
                    <OnHide>
                        <%-- Collapse down to 0px and fade out --%>
                        <Parallel Duration=".4">
                            <FadeOut />
                            <Length PropertyKey="height" StartValueScript="$find('AutoCompleteEx1')._height" EndValue="0" />
                        </Parallel>
                    </OnHide>
        </Animations>
    </cc1:AutoCompleteExtender>
    </form>
    <script type="text/javascript">
        // Work around browser behavior of "auto-submitting" simple forms  
        var frm = document.getElementById("aspnetForm");
        if (frm) {
            frm.onsubmit = function () { return false; };
        }  
    </script>
    
</body>
</html>
