<%@ Page Language="C#" AutoEventWireup="true" CodeFile="UploadOpeningBalance.aspx.cs" Inherits="Design_EDP_UploadOpeningBalance" MasterPageFile="~/DefaultHome.master" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript">
        function Validate() {
            if ($("[id*=ddlCentre]  option:selected").val() == "0") {
                $("#<%=lblMsg.ClientID%>").text('Please Select Centre');
                return false;
            }
        }
    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div style="text-align: center">
                <b>Import Opening Balance&nbsp;</b><br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
            </div>
        </div>

        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="col-md-3">
                        <label class="pull-left">
                            Centre
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:DropDownList ID="ddlCentre" runat="server" ToolTip="Select Centre" CssClass="requiredField">
                        </asp:DropDownList>
                    </div>

                    <div class="col-md-4">
                        <label class="pull-left">
                            Upload Excel Sheet
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4">
                        <asp:FileUpload ID="fuOpeningBalance" runat="server" />
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">
                        </label>
                        <b class="pull-right"></b>
                    </div>
                    <div class="col-md-5">
                    </div>

                </div>
                <div class="col-md-1"></div>
            </div>
        </div>

        <div class="POuter_Box_Inventory" style="text-align: center">
            &nbsp;<asp:Button ID="btnSave" runat="server" Text="Upload Excel Sheet" OnClick="btnSave_Click" OnClientClick="return Validate()" CssClass="ItDoseButton" />
              &nbsp;<asp:Button ID="btnCheckError" runat="server" Text="Check Errors" OnClick="btnCheckError_Click" CssClass="ItDoseButton" />
               &nbsp;<asp:Button ID="btnPatientDetail" runat="server" Text="Patient Detail" OnClick="btnPatientDetail_Click" CssClass="ItDoseButton" />
              &nbsp;<asp:Button ID="btnUploadData" runat="server" Text="Update Opening Balance" OnClick="btnUploadData_Click" CssClass="ItDoseButton" />
       &nbsp;<asp:Button ID="btnUpdateFinance" runat="server" Text="Update Finance" OnClick="btnUpdateFinance_Click" CssClass="ItDoseButton" />
            
              </div>
        <div class="POuter_Box_Inventory" style="text-align: left">
            &nbsp; Note : The following things should be noted before uploading the ratelist
            :--<br />
            &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 1) The file must be .xls and .xlxs file.<br />
            &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 3) No comma will be allowed in any non-numeric
            fields and any alphabets in numeric fields.<br />
            &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 4) Avoid any apostrophe ( ' ).<br />
          <%--   &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 5) First Sheet Bill Detail, Second Sheet Panel, Third Sheet Doctor ( ' ).<br />--%>
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
                          <asp:TemplateField HeaderText="UHID">
                            <ItemTemplate>
                                <%# Eval("UHID")%>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle"/>
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                          <asp:TemplateField HeaderText="BillNo">
                            <ItemTemplate>
                                <%# Eval("BillNo")%>
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
</asp:Content>
