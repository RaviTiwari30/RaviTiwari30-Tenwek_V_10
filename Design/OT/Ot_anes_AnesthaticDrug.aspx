<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Ot_anes_AnesthaticDrug.aspx.cs" Inherits="Design_OT_Ot_anes_AnesthaticDrug" %>


<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>



<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <style type="text/css">
         .holder {
                position: relative;
            }
            .dropdown {
                width:500px;
                height:120px;
                overflow-y:auto;
                margin-top:25px;
                position: absolute;
                z-index:999;
                border: 1px solid black;
                display: none;
                background-color:white;
                color:black;
            }

            input:focus + .dropdown {
                display: block;
            }
        .deleted {
            display:none;
        }
        .ajax__scroll_none {
    overflow: visible !important;
    z-index: 10000 !important;
}
    </style>
    <link href="../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />
    <link rel="Stylesheet" href="../../Styles/framestyle.css" />
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
    <script src="../../Scripts/ipad.js" type="text/javascript"></script>
    <script type="text/javascript" src="../../Scripts/CPOE_AddToFavorites.js"></script>
    <script src="../../Scripts/Message.js" type="text/javascript"></script>
    <script src="../../Scripts/chosen.jquery.min.js"></script>
    <link href="../../Styles/chosen.css" rel="stylesheet" />
    <script type="text/javascript">
        function getDrugName(dn) {
            //alert(dn);
            if ($("#txtDrugs").val() == "")
            {
                $("#txtDrugs").val( dn);
            }
            else
            {
                $("#txtDrugs").val($("#txtDrugs").val() + " ," + dn);
            }
            $('.dropdown').hide();
        }

        function search() {
            var key = $('#txtDrugs1').val();
            //alert(key);
            jQuery.ajax({
                type: "POST",
                url: "Ot_anes_AnesthaticDrug.aspx/BindSearch",
                data: '{key:"' + key + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                success: function (response) {
                    if ((response.d != null) && (response.d != "")) {
                        Newitem = jQuery.parseJSON(response.d);


                        var str = "<table style='width:100%;' border='1'>";
                        for (var i = 0; i < Newitem.length; i++) {
                            var objrow = Newitem[i];
                            str += "<tr><td class='GridViewLabItemStyle' ><a  onclick='getDrugName(&quot;" + objrow.NAME + "&quot;);'>" + objrow.NAME + "</a></td></tr>";

                        }
                        str += "</table>";
                        $(".dropdown").html(str);
                        $(".dropdown").show();
                    }
                },
                error: function (e) { }
            });
        }

        var togglePatientDetailSection = function (el, isForceHide) {
            var x = $(el).parent().find('.row:first');
            if (x.css('display') == 'block') {
                x.css('display', 'none');
            } else {
                x.css('display', 'block');
            }
        }

    </script>


    <style>
        .ClassMTop {
            margin-top: -5px;
            margin-left: -20px;
        }

        .ClassMBold {
            font-weight: bold;
        }

        .ClassHeading {
            font-size: 20px;
        }

        .ClassSubHeading {
            font-size: 16px;
        }

        .ClassNormalform {
            margin-left: 20px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">
            <asp:ScriptManager ID="ScriptManager" runat="server">
            </asp:ScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <div class="ClassHeading" style="text-align: center">
                    <b>Anaesthetic Drugs</b>
                </div>
                <asp:Label ID="lblMsg" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError" />
            </div>
            <div class="POuter_Box_Inventory">
                <div class="row">
                    <div class="col-md-3">Date :</div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtAnesDate" runat="server" ClientIDMode="Static" autocomplete="off"></asp:TextBox>
                        <cc1:CalendarExtender ID="calDate" PopupButtonID="imgPopup" runat="server" TargetControlID="txtAnesDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>

                    </div>
                    <div class="col-md-3">Time :</div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtAnesTime" runat="server" Width="100px"></asp:TextBox>
                        <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtAnesTime"
                            Mask="99:99" MaskType="Time" AcceptAMPM="true" />

                        <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtAnesTime"
                            ControlExtender="MaskedEditExtender1" IsValidEmpty="true" EmptyValueMessage="Time Required"
                            InvalidValueMessage="Invalid Time" ValidationGroup="save1"></cc1:MaskedEditValidator>
                        <br />
                        <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3">Medicines :</div>
                    <div class="col-md-20">
                        <input type="text"   ID="txtDrugs1"  onkeyup="search();" placeholder="Search Medicine" />
                        <asp:TextBox ID="txtDrugs" runat="server" TextMode="MultiLine" style="height:100px"  ></asp:TextBox>
                        <div class="dropdown"  style='width:500px;height:400px;display:none;z-index:999'>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3">N<sub>2</sub>O / Air :</div>
                    <div class="col-md-20">
                        <asp:TextBox ID="txtN2O" runat="server"></asp:TextBox>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3">O<sub>2 :</sub></div>
                    <div class="col-md-20">
                        <asp:TextBox ID="txtO2" runat="server"></asp:TextBox>
                    </div>

                </div>

                <div class="row">
                    <div class="col-md-3">Volatile Agents :</div>
                    <div class="col-md-15">
                        <asp:TextBox ID="txtVolatileAgent" runat="server" TextMode="MultiLine" style="height:100px"></asp:TextBox>
                    </div>
                    <div class="col-md-2">Time :</div>
                    <div class="col-md-4">
                        <asp:TextBox ID="txtVaTime" runat="server" Width="100px"></asp:TextBox>
                        <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtVaTime"
                            Mask="99:99" MaskType="Time" AcceptAMPM="true" />

                        <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlToValidate="txtVaTime"
                            ControlExtender="MaskedEditExtender1" IsValidEmpty="true" EmptyValueMessage="Time Required"
                            InvalidValueMessage="Invalid Time" ValidationGroup="save1"></cc1:MaskedEditValidator>
                        <br />
                        <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
                    </div>

                </div>
                <div class="row">
                    <div class="col-md-3">Antibiotics :</div>
                    <div class="col-md-15">
                        <asp:TextBox ID="txtAntibiotics" runat="server" TextMode="MultiLine" style="height:100px"></asp:TextBox>
                    </div>
                    <div class="col-md-2">Time :</div>
                    <div class="col-md-4">
                        <asp:TextBox ID="txtAntibioticsTime" runat="server" Width="100px"></asp:TextBox>
                        <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtAntibioticsTime"
                            Mask="99:99" MaskType="Time" AcceptAMPM="true" />

                        <cc1:MaskedEditValidator ID="MaskedEditValidator2" runat="server" ControlToValidate="txtAntibioticsTime"
                            ControlExtender="MaskedEditExtender1" IsValidEmpty="true" EmptyValueMessage="Time Required"
                            InvalidValueMessage="Invalid Time" ValidationGroup="save1"></cc1:MaskedEditValidator>
                        <br />
                        <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
                    </div>

                </div>


                <div class="row">
                    <div class="col-md-3">
                        Tourniquet :
                    </div>
                    <div class="col-md-5">
                        <asp:CheckBox ID="rblTourniquet" runat="server"  />
                        
                    </div>




                </div>


                 <div class="row">
                    <div class="col-md-3">
                        Site :
                    </div>
                    <div class="col-md-5">
                          <asp:TextBox ID="txtSite1" runat="server"></asp:TextBox>
                    </div>
                     <div class="col-md-5">
                          <asp:TextBox ID="txtSite2" runat="server"></asp:TextBox>
                    </div>

                     <div class="col-md-5">
                          <asp:TextBox ID="txtSite3" runat="server"></asp:TextBox>
                    </div>



                </div>
            </div>
             <div class="POuter_Box_Inventory" style="text-align: center;">

                <asp:Button ID="btnUpdate" runat="server" Text="Update" class="ItDoseButton" OnClick="btnUpdate_Click" Visible="false" />
                <asp:Button ID="btnSave" runat="server" Text="Save" class="ItDoseButton" OnClick="btnSave_Click" />
                <asp:Label ID="lblID" Text="" runat="server" Style="display: none" ClientIDMode="Static"></asp:Label>
                <asp:Button ID="btnCancel" runat="server" Text="Cancel" class="ItDoseButton" OnClick="btnCancel_Click" />
            </div>
        
            <div class="POuter_Box_Inventory" style="text-align: center">
                <asp:GridView ID="grdPhysical" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" OnRowCommand="grdPhysical_RowCommand" TabIndex="6">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Date">
                            <ItemTemplate>
                                <asp:Label ID="lblDate" runat="server" Text='<%#Eval("AnesDrugDate") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Time">
                            <ItemTemplate>
                                <asp:Label ID="lblTime" runat="server" Text='<%#Eval("AnesDrugTime") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                         <asp:TemplateField HeaderText="Medicines">
                            <ItemTemplate>
                                <asp:Label ID="lblDrugs" runat="server" Text='<%#Eval("Drugs") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="N2O">
                            <ItemTemplate>
                                <asp:Label ID="lblN2O" runat="server" Text='<%#Eval("N2O") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="O2">
                            <ItemTemplate>
                                <asp:Label ID="lblO2" runat="server" Text='<%#Eval("O2") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Volatile Agents">
                            <ItemTemplate>
                                <asp:Label ID="lblVolatileAgents" runat="server" Text='<%#Eval("VolatileAgent") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Time">
                            <ItemTemplate>
                                <asp:Label ID="lblVATime" runat="server" Text='<%#Eval("VATime") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>

                         <asp:TemplateField HeaderText="Antibiotics">
                            <ItemTemplate>
                                <asp:Label ID="lblAntibiotics" runat="server" Text='<%#Eval("Antibiotic") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                         <asp:TemplateField HeaderText="Time" >
                            <ItemTemplate>
                                <asp:Label ID="lblAntibioticsTime" runat="server" Text='<%#Eval("AntibioticTime") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>


                        <asp:TemplateField HeaderText="Tourniquet" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblTourniquet" runat="server" Text='<%#Eval("Tourniquet") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Tourniquet" >
                            <ItemTemplate>
                                <asp:Label ID="lblTourniquettext" runat="server" Text='<%#Eval("TourniquetText") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Site">
                            <ItemTemplate>
                                <asp:Label ID="lblSite" runat="server" Text='<%#Eval("Site") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>



                        <asp:TemplateField HeaderText="Site" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblSite1" runat="server" Text='<%#Eval("Site1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Site" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblSite2" runat="server" Text='<%#Eval("Site2") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Site" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblSite3" runat="server" Text='<%#Eval("Site3") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Edit">
                            <ItemTemplate>
                                <asp:ImageButton ID="imgbtnEdit" AlternateText="Edit" CommandName="Change" CommandArgument='<%#Container.DataItemIndex%>' ImageUrl="~/Images/edit.png" runat="server" />
                                <asp:Label ID="lblUserID" Text='<%#Eval("EntryBy") %>' runat="server" Visible="false"></asp:Label>
                                <asp:Label ID="lblgdID" Text='<%#Eval("ID") %>' runat="server" Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
           </div>

    </form>
</body>
</html>

