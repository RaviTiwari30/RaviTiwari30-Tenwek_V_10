<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="UploadTempRateList.aspx.cs" Inherits="Design_EDP_UploadTempRateList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div style="text-align: center">
                <b>Upload Temporary Ratelist&nbsp;</b><br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                <br />
            </div>
        </div>

        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Panel</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlPanel" runat="server" TabIndex="1" Width="200px" ClientIDMode="Static">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                             <label class="pull-left">Type</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-10">
                            <asp:RadioButtonList ID="rblType" runat="server" RepeatDirection="Horizontal" ClientIDMode="Static">
                                <asp:ListItem Text="Investigations" Value="Invst" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="Services" Value="Service"></asp:ListItem>
                                <asp:ListItem Text="IPD Packages" Value="Packages"></asp:ListItem>
                                <asp:ListItem Text="Surgery" Value="Surgery"></asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                       

                    </div>
                <div class="row">
                     <div class="col-md-3">
                            <label class="pull-left">Upload CSV File</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:FileUpload ID="f_ratelist" runat="server" />
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>

        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnSave" runat="server" Text="Upload"
                CssClass="ItDoseButton" OnClick="btnSave_Click" Style="margin-top: 7px; width: 100px;" />
        </div>
    <div class="POuter_Box_Inventory" style="text-align: left">
        &nbsp; Note : The following things should be noted before uploading the ratelist
            :--<br />
        &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 1) The file must be .csv file in ms-dos
            type.<br />
        &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 2) The file must have ItemName and ItemCode Columns.<br />
        &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 3) No comma will be allowed in any non-numeric
            fields and any alphabets in numeric fields.<br />
        &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 4) Any Sppecial Symbol like (',",;,#) should be avoided.<br />
        &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 5) For OPD Rates Column name should be 'OPD' and for IPD Rates Column Names should be as the Abbreviation of room type master table.<br />
        <br />
    </div>
    </div>
    <script>
        $(document).ready(function () {
            $('#ddlPanel').chosen();

        });

    </script>
</asp:Content>

