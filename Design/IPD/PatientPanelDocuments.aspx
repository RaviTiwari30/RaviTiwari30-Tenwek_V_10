<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PatientPanelDocuments.aspx.cs"
    Inherits="Design_IPD_PatientPanelDocuments" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml"  >
<head id="Head1" runat="server">
    <title>Untitled Page</title>
    <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script src="../../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
   
</head>
<body>

    <script type="text/javascript">

        var oldgridcolor;
        function SetMouseOver(element) {
            oldgridcolor = element.style.backgroundColor;
            element.style.backgroundColor = 'aqua';
            element.style.cursor = 'pointer';

        }
        function SetMouseOut(element) {
            element.style.backgroundColor = oldgridcolor;

        }
        $(document).ready(function () {
            $("input[id*=chkSelect]").each(function () {
                //this.onclick = function () {
                if (this.checked == true) {
                    $(this).closest("tr").find("input[id*=FileUpload1]").removeAttr('readOnly', 'readOnly');
                    // $(this).closest("tr").find("input[id*=btnView]").removeAttr('readOnly', 'readOnly');
                }
                else {
                    $(this).closest("tr").find("input[id*=FileUpload1]").attr('readOnly', 'readOnly');
                    // $(this).closest("tr").find("input[id*=btnView]").attr('disabled', 'disabled');

                }
                // };
            });
            $("input[id*=chkSelect]").click(function () {
                if (this.checked == true) {
                    $(this).closest("tr").find("input[id*=FileUpload1]").removeAttr('readOnly', 'readOnly');
                    // $(this).closest("tr").find("input[id*=btnView]").removeAttr('disabled', 'disabled');

                }
                else {
                    $(this).closest("tr").find("input[id*=FileUpload1]").attr('readOnly', 'readOnly');
                    //  $(this).closest("tr").find("input[id*=btnView]").attr('disabled', 'disabled');

                }
            });

        });
        function validate(btn) {
            btn.disabled = true;
            btn.value = 'Submitting...';
            __doPostBack('btnSave', '');
        }
    </script>
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <cc1:ToolkitScriptManager runat="server" ID="scrMgr1"></cc1:ToolkitScriptManager>
                <b>Patient Panel Document Status</b><br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>

            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Bill Details
                </div>
                <table style="width: 100%;border-collapse:collapse">
                    <tr>
                        <td style="width: 20%" align="right">Bill Amount :&nbsp;
                        </td>
                        <td align="left" >
                            <asp:Label ID="lblBillAmount" runat="server" CssClass="ItDoseLabelSp" />
                        </td>
                        <td style="width: 20%;" align="right">Panel :&nbsp;
                        </td>
                        <td  style="text-align:left">
                            <asp:Label ID="lblPanelNAme" runat="server" CssClass="ItDoseLabelSp" />
                        </td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td align="right" style="width: 20%">Final Approval Amount :&nbsp;
                        </td>
                        <td align="left" >
                            <asp:Label ID="lblApprovalAmt" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                        </td>
                        <td align="right" style="width: 20%">Claim No. :&nbsp;
                        </td>
                        <td style="text-align: left" >
                            <asp:Label ID="lblClaimNo" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                        </td>
                        <td></td>
                        <td></td>
                    </tr>
                </table>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Panel Approval Details &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="background-color: LightGreen">
                    &nbsp;Document Uploaded</span>&nbsp;&nbsp; <span style="background-color: LightPink">Document Not Uploaded</span>
                </div>
            
                    <asp:GridView ID="grdDocuments" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                        OnRowDataBound="grdDocuments_RowDataBound" Width="100%" OnRowCommand="grdDocuments_RowCommand">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField HeaderText="Select">
                                <ItemTemplate>
                                    <asp:CheckBox ID="chkSelect" runat="server" Checked='<%# Util.GetBoolean(Eval("Status")) %>' />
                                    <asp:Label ID="lblStatus" runat="server" Visible="false" Text='<%# Eval("Status") %>' />
                                    <asp:Label ID="lblPanelDocumentID" runat="server" Visible="false" Text='<%# Eval("PanelDocumentID") %>' />
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Document Name">
                                <ItemTemplate>
                                    <asp:Label ID="lblDocument" runat="server" Text='<%# Eval("Document") %>' />
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="400px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Browse">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <asp:FileUpload ID="FileUpload1" runat="server" EnableTheming="false" />
                                    <asp:Label ID="lblFilePath" Visible="false" runat="server" Text='<%#Eval("FilePath") %>'></asp:Label>
                                    <asp:Label ID="lblFileName" Visible="false" runat="server" Text='<%#Eval("FileName") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="View">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <asp:ImageButton ID="btnView" runat="server" ToolTip="View Document" ImageAlign="middle"
                                        CausesValidation="false" ImageUrl="~/Images/view.GIF" Enabled='<%# Util.GetBoolean(Eval("FileStatus")) %>'
                                        CommandName="VIEW" CommandArgument='<%# Eval("FilePath") %>' />
                                    <%--<asp:Button ID="btnView" runat="server" Enabled='<%# Util.GetBoolean(Eval("FileStatus")) %>' CommandName="VIEW" CommandArgument='<%# Eval("FilePath") %>'
                                        Text="View"  />--%></td>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton" OnClick="btnSave_Click"
                    Text="Save" OnClientClick="return validate(this);" />
            </div>
        </div>
    </form>
</body>
</html>
