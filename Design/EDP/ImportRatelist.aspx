<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ImportRateList.aspx.cs" Inherits="Design_EDP_ImportRateList" MasterPageFile="~/DefaultHome.master" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript">
        function Validate() {
            if ($("[id*=ddlCentre]  option:selected").val() == "0")
            {
                $("#<%=lblMsg.ClientID%>").text('Please Select Centre');
                return false;
            }
        }
    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div style="text-align: center">
            <b>Import New/Updated Ratelist&nbsp;</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="col-md-3"><label class="pull-left">Type</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:RadioButtonList ID="rbtnType" runat="server" AutoPostBack="true" RepeatDirection="Horizontal" OnSelectedIndexChanged="rbtntype_changed">
                            <asp:ListItem Selected="True" Value="0">OPD</asp:ListItem>
                            <asp:ListItem Value="1">IPD</asp:ListItem>
                        </asp:RadioButtonList>
                    </div>
                    <div class="col-md-3"></div>
                    <div class="col-md-5">
                        <asp:RadioButtonList ID="rbtnipdtype" runat="server" AutoPostBack="false"
                            RepeatDirection="Horizontal" Visible="false">
                            <asp:ListItem Selected="True" Value="0">Services</asp:ListItem>
                            <asp:ListItem Value="1">Surgery</asp:ListItem>
                        </asp:RadioButtonList>
                    </div>
                    <div class="col-md-3"></div>
                    <div class="col-md-5"></div>
                </div>
                <div class="col-md-1"></div>
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
                    <div class="col-md-3">
                         <label class="pull-left">
                                Panel
                            </label>
                            <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:DropDownList ID="ddlPanel" runat="server" AutoPostBack="True" TabIndex="1" OnSelectedIndexChanged="ddlPanel_SelectedIndexChanged">
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-3">
                         <label class="pull-left">
                                Schedule Charge
                            </label>
                            <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                           <asp:DropDownList ID="ddlScheduleCharges" runat="server" TabIndex="2">
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="content" style="text-align: center">
                <b>Upload Excel Sheet :         </b>
                <asp:FileUpload ID="FileUpload1" runat="server" />
            </div>
        </div>

        <div class="POuter_Box_Inventory" style="text-align: center">
            &nbsp;<asp:Button ID="btnSave" runat="server" Text="Update" OnClick="btnSave_Click" OnClientClick="return Validate()"
                CssClass="ItDoseButton" />
        </div>
        <div class="POuter_Box_Inventory" style="text-align: left">
            &nbsp; Note : The following things should be noted before uploading the ratelist
            :--<br />
            &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 1) The file must be Excel (xlsx) file in 
            type.<br />
            &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 2) The file must be created from Ratelist
            report.<br />
            &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 3) No comma will be allowed in any non-numeric
            fields and any alphabets in numeric fields.<br />
            &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 4) Avoid any apostrophe ( ' ) in the non-numeric
            fields.<br />
            &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 5) In the Excel no Cell having the blank value in every column, In place of blank value Enter "@"
            fields.<br />
            <br />
        </div>

    </div>
</asp:Content>
