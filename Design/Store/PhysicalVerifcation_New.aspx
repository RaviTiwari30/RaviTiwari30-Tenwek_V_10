<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="PhysicalVerifcation_New.aspx.cs"  Inherits="Design_Store_PhysicalVerifcation_New" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <script type="text/javascript">
        function Validate() {
            if ($("[id*=ddlCentre]  option:selected").val() == "0") {
                $("#<%=lblMsg.ClientID%>").text('Please Select Centre');
                return false;
            }
        }
        $(document).ready(function () {
            blockUIOnRequest();
        });
        var blockUIOnRequest = function () {
            var prm = Sys.WebForms.PageRequestManager.getInstance();
            prm.add_beginRequest(function () {
                $.blockUI({ message: '<h3><img src="../../Images/loadingAnim.gif" /><br/>Just a moment...</h3>' });
            });
            prm.add_endRequest(function () {
                $.unblockUI();
            });
        }
    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div style="text-align: center">
                <b>Import Stock Physical Verification&nbsp;</b><br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
            </div>
        </div>

        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-22">
                    <div class="col-md-4">
                        <label class="pull-left">
                            Centre
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4">
                        <asp:DropDownList ID="ddlCentre" runat="server" ToolTip="Select Centre" CssClass="requiredField">
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">
                            Store Type
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:DropDownList ID="ddlStoreType" runat="server" ToolTip="Select Centre" CssClass="requiredField">
                            <asp:ListItem Value="STO00001">Medical Store</asp:ListItem>
                            <asp:ListItem Value="STO00002">General Store</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                     <div class="col-md-3">
                        <label class="pull-left">
                           Department
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:DropDownList ID="ddlDepartment" runat="server" ToolTip="Select Department" CssClass="requiredField">
                        </asp:DropDownList>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-22">
                 <div class="col-md-4">
                        <label class="pull-left">
                            Upload Excel Sheet
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4">
                        <asp:FileUpload ID="fustockAdjustment" runat="server" />
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">
                        </label>
                        <b class="pull-right"></b>
                    </div>
                    <div class="col-md-5">
                    </div>
            </div><div class="col-md-1"></div></div>
        </div>

        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnstockdownload" runat="server" Text="Download Stock Excel Sheet" OnClick="btnstockdownload_Click" OnClientClick="return Validate()" CssClass="ItDoseButton" />
            &nbsp;<asp:Button ID="btnSave" runat="server" Text="Upload Stock Excel Sheet" OnClick="btnSave_Click" OnClientClick="return Validate()" CssClass="ItDoseButton" />
            &nbsp;&nbsp;<asp:Button ID="btnUploadData" runat="server" Text="Update Stock Balance" Visible="false" OnClick="btnUploadData_Click"  CssClass="ItDoseButton" />
            &nbsp;</div>
        <div class="POuter_Box_Inventory" style="text-align: left">
            &nbsp; Note : The following things should be noted before uploading the ratelist
            :--<br />
            &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 1) The file must be .csv<br />
            &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 3) No comma will be allowed in any non-numeric
            fields and any alphabets in numeric fields.<br />
            &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 4) Avoid any apostrophe ( ' ).<br />
            <br />
        </div>
        <div class="POuter_Box_Inventory" style="text-align: left">
                <asp:GridView ID="gvError" runat="server"  AutoGenerateColumns="False"  CssClass="GridViewStyle" Width="100%">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%#Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                        </asp:TemplateField>
                          <asp:TemplateField HeaderText="Master Name">
                            <ItemTemplate>
                                <%# Eval("TypeName")%>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle"/>
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                          <asp:TemplateField HeaderText="Excel Name">
                            <ItemTemplate>
                                <%# Eval("ItemName")%>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                          <asp:TemplateField HeaderText="ItemID">
                            <ItemTemplate>
                                <%# Eval("ItemID")%>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Error">
                            <ItemTemplate>
                                <%# Eval("Error")%>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
        </div>
    </div>
    <script type="text/javascript">
        function unblockUI() {
                $.unblockUI();
        }
        function blockUI() {
                $.blockUI({ message: '<h1>Please wait..</h1>' });
        }
        $(function () {
            //blockui();
        });
    </script>
</asp:Content>

