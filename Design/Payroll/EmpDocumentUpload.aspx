<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="EmpDocumentUpload.aspx.cs" Inherits="Design_Payroll_EmpDocumentUpload" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script  type="text/javascript" src="../../Scripts/Message.js"></script>
    
    <script type="text/javascript" >

        $(document).ready(function () {
            $("input[id*=chkSelect]").each(function () {
                if (this.checked == true) {
                    $(this).closest("tr").find("input[id*=ddlupload_doc]").removeAttr('readOnly', 'readOnly');
                }
                else {
                    $(this).closest("tr").find("input[id*=ddlupload_doc]").attr('readOnly', 'readOnly');

                }
            });
            $("input[id*=chkSelect]").click(function () {
                if (this.checked == true) {
                    $(this).closest("tr").find("input[id*=ddlupload_doc]").removeAttr('readOnly', 'readOnly');

                }
                else {
                    $(this).closest("tr").find("input[id*=ddlupload_doc]").attr('readOnly', 'readOnly');

                }
            });

        });

        function validate() {
            for (cnt = 0; cnt < gvchks.length; cnt++) {
                if (document.getElementById(gvchks[cnt]) && document.getElementById(gvchks[cnt]).checked) {
                    strFileName = document.getElementById(gvfls[cnt]).value;
                    if (strFileName == '') {
                        $("#<%=lblmsg.ClientID %>").text('Please Select File to Upload');
                        document.getElementById(gvfls[cnt]).focus();
                        return false;
                    }
                }

            }
            return true;
        }
        //        $(document).ready(function () {
        //            $("input[id*=chkSelect]").each(function () {
        //                if (this.checked == true) {
        //                    $(this).closest("tr").find("input[id*=ddlupload_doc]").change(function () {
        //                        var fileExtension = ['jpeg', 'jpg', 'png', 'gif', 'bmp'];
        //                        if ($.inArray($(this).val().split('.').pop().toLowerCase(), fileExtension) == -1) {
        //                            alert("Only '.jpeg','.jpg', '.png', '.gif', '.bmp' formats are allowed.");
        //                            return false;
        //                        }

        //                    });
        //                }
        //            });
        //        });
        function validate() {

        }
    </script>

    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sm" runat="server" />
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Employee Document Upload </b>
            <br />
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                &nbsp;
            </div>
            <table border="0" style="width: 100%">
                <tr>
                    <td style="width: 21%; height: 11px;" align="right">Employee ID :&nbsp;
                    </td>
                    <td style="width: 18%; height: 11px;">
                        <asp:TextBox ID="txtEmpID" runat="server" MaxLength="20" TabIndex="1" ToolTip="Enter Employee ID"></asp:TextBox>
                    </td>
                    <td style="width: 20%; height: 11px;" align="right">Employee Name :&nbsp;
                    </td>
                    <td style="width: 20%; height: 11px;">
                        <asp:TextBox ID="txtEmpName" runat="server" MaxLength="50" TabIndex="2" ToolTip="Enter Employee Name"></asp:TextBox>
                    </td>
                    <td style="width: 25%; height: 11px;"></td>
                </tr>
                <tr>
                    <td style="width: 21%; height: 18px;"></td>
                    <td style="width: 18%; height: 18px;"></td>
                    <td style="width: 20%; height: 18px;"></td>
                    <td style="width: 20%; height: 18px;"></td>
                    <td style="width: 25%; height: 18px;"></td>
                </tr>
                <tr>
                    <td style="width: 21%"></td>
                    <td style="width: 18%"></td>
                    <td style="width: 20%" align="center">
                        <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click"
                            CssClass="ItDoseButton" TabIndex="3" ToolTip="Click to Search" />
                    </td>
                    <td style="width: 20%"></td>
                    <td style="width: 25%"></td>
                </tr>
                <tr>
                    <td align="center" colspan="5" style="height: 18px"></td>
                </tr>
            </table>
        </div>
        <asp:Panel ID="pnlhide" runat="server" Visible="false">
            <div class="POuter_Box_Inventory">
                <div class="content" style="text-align: left;">
                    <b>
                        <br />
                        Employee ID &nbsp; :&nbsp;<asp:Label ID="lblEmpID" runat="server" CssClass="ItDoseLabelSp"></asp:Label>&nbsp;&nbsp;&nbsp;&nbsp;Employee
                        Name &nbsp;:&nbsp;<asp:Label ID="lblName" CssClass="ItDoseLabelSp" runat="server"></asp:Label>
                        &nbsp;&nbsp;Designation &nbsp;:&nbsp;<asp:Label ID="lblDesignation" CssClass="ItDoseLabelSp"
                            runat="server"></asp:Label>
                    </b>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <div class="Purchaseheader">
                    Verification Details &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="background-color: LightGreen">
                        &nbsp;Document Uploaded</span>&nbsp;&nbsp; <span style="background-color: LightPink">Document Not Uploaded</span>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <asp:Label ID="lblNote" runat="server" Text="Note : Only pdf,jpg,jpeg,doc,docx,gif file accepted."></asp:Label>
                </div>
                <asp:Panel ID="pnl" runat="server" ScrollBars="Vertical" Height="300">
                    <table border="0" style="width: 500">
                        <tr>
                            <td align="center" colspan="5">
                                <asp:GridView ID="EarningGrid" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                                    OnRowCommand="EarningGrid_RowCommand" OnRowDataBound="EarningGrid_RowDataBound">
                                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="Select">
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkSelect" runat="server" Checked='<%# Util.GetBoolean(Eval("Status")) %>' />
                                                <asp:Label ID="lblStatus" runat="server" Visible="false" Text='<%# Eval("Status") %>' />
                                                <asp:Label ID="lblVerificationID" runat="server" Visible="false" Text='<%# Eval("ID") %>' />
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Document Name">
                                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                                            <ItemTemplate>
                                                <asp:Label ID="lblName" runat="server" Text='<%#Eval("Name") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Upload">
                                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                            <ItemTemplate>
                                                <asp:FileUpload ID="ddlupload_doc" runat="server" />
                                                <asp:Label ID="lblFilePath" Visible="false" runat="server" Text='<%#Eval("FilePath") %>'></asp:Label>
                                                <asp:Label ID="lblFileName" Visible="false" runat="server" Text='<%#Eval("FileName") %>'></asp:Label>
                                                <%--<asp:RegularExpressionValidator ID="regreg" Display="None" ErrorMessage="Only jpg,png,bmp,doc File Upload"
                                                SetFocusOnError="true" runat="server" ControlToValidate="ddlupload_doc" ValidationExpression="^([0-9a-zA-Z_\-~ :\\])+(.jpg|.JPG|.jpeg|.JPEG|.bmp|.BMP|.png|.PNG|.doc)$"></asp:RegularExpressionValidator>--%>
                                                <%--   <asp:CustomValidator ID="CustomValidator1" runat="server" ClientValidationFunction="ValidateFileUploadExtension"
                                                    ErrorMessage="Please select valid gif/jpeg/jpg/png/doc/docx/xls/xlsx file" Font-Size="16px"
                                                    ForeColor="red"></asp:CustomValidator>--%>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="View">
                                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                            <ItemTemplate>
                                                <asp:ImageButton ID="imbView" runat="server" CausesValidation="false" CommandName="AView"
                                                    ImageUrl="~/Images/view.gif" CommandArgument='<%# Eval("FilePath")  %>' Enabled='<%# Util.GetBoolean(Eval("FileStatus")) %>' />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <%--<asp:TemplateField HeaderText="Available">
                                        <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                        <ItemTemplate>
                                            <asp:Label ID="lblChkImage" runat="server" Text='<%#Eval("Visible") %>' Visible="false"></asp:Label>
                                            <asp:ImageButton ID="check_icon" Height="20" Width="20" runat="server" CausesValidation="false"
                                                ImageUrl="~/Images/A_Chk.gif" />
                                        </ItemTemplate>
                                    </asp:TemplateField>--%>
                                    </Columns>
                                </asp:GridView>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <asp:Button ID="btnSave" TabIndex="4" runat="server" Text="Upload" OnClick="btnSave_Click" CssClass="ItDoseButton"/>&nbsp;
            </div>
        </asp:Panel>
    </div>
</asp:Content>