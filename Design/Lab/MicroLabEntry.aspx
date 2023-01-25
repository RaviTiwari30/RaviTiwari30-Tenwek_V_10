<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="MicroLabEntry.aspx.cs" Inherits="Design_Lab_MicroLabEntry" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="Pbody_box_inventory" style="width: 1300px;">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>

        <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="">
                <b>Microbiology Culture MicroScopy,Plating and Incubation </b>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <table style="width: 100%">
                <tr>
                    <td width="50%" valign="top">
                        <div   style="color: maroon;border:1px solid black;" >
                        <div class="row">
                            <div class="col-md-5">
                                <label class="pull-left"><b>Entry Type</b></label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-7">
                                 <asp:DropDownList ID="ddltype" runat="server" Width="128">
                                        <asp:ListItem Value="Microscopic">Microscopy</asp:ListItem>
                                        <asp:ListItem Value="Plating">Plating</asp:ListItem>
                                        <asp:ListItem Value="Incubation">Incubation</asp:ListItem>
                                        <asp:ListItem Value="ALL">ALL</asp:ListItem>
                                    </asp:DropDownList>
                            </div>
                              <div class="col-md-5">
                                    <label class="pull-left">
                                        <b>UHID No.</b>
                                    </label>
                                <b class="pull-right">:</b>
                               </div>
                            <div class="col-md-7">
                                   <asp:TextBox ID="txtvisitno" runat="server" Width="128"></asp:TextBox>
                            </div>
                            
                        </div>
                         <div class="row">
                                <div class="col-md-5">
                                    <label class="pull-left">
                                        <b>From Date</b>
                                    </label>
                                <b class="pull-right">:</b>
                               </div>
                            <div class="col-md-7">
                                   <asp:TextBox ID="dtFrom" runat="server" ReadOnly="true" Width="128px"></asp:TextBox> 
                                    <cc1:CalendarExtender runat="server" ID="ce_dtfrom"
                                        TargetControlID="dtFrom"
                                        Format="dd-MMM-yyyy"
                                        PopupButtonID="dtFrom" />
                            </div>
                            <div class="col-md-5">
                                <label class="pull-left"><b>To Date</b></label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-7">
                                 <asp:TextBox ID="dtTo" runat="server" ReadOnly="true" Width="128px"></asp:TextBox>
                                    <cc1:CalendarExtender runat="server" ID="ce_dtTo"
                                        TargetControlID="dtTo"
                                        Format="dd-MMM-yyyy"
                                        PopupButtonID="dtTo" />
                            </div>
                             
                        </div>
                         <div class="row">
                            <div class="col-md-5">
                                <label class="pull-left"><b>Barcode No.</b></label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-7">
                                  <asp:TextBox ID="txtsinno" runat="server" Width="128"></asp:TextBox>
                            </div>
                               <div class="col-md-5">
                                    <label class="pull-left">
                                        <b></b>
                                    </label>
                                <b class="pull-right"></b>
                               </div>
                            <div class="col-md-7"> 
                            </div>
                        </div>
                        <div class="row" style="text-align:center;">
                            <input id="btnSearch" type="button" value="Search" onclick="searchdata('')" />
                        </div>
                        <div class="row" style="text-align:center;margin-left: 105px;">
                             <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: lightyellow;" class="circle" onclick="searchdata('Pending')"></button>
                                            <b style="margin-top: 5px; margin-left: 5px; float: left">Pending</b>
                                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: pink;" class="circle" onclick="searchdata('Microscopic')"></button>
                                            <b style="margin-top: 5px; margin-left: 5px; float: left">Microscopic</b>
                                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: lightgreen;" class="circle" onclick="searchdata('Plating')"></button>
                                            <b style="margin-top: 5px; margin-left: 5px; float: left">Plating</b>
                                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: #00FFFF;" class="circle" onclick="searchdata('Plating')"></button>
                                            <b style="margin-top: 5px; margin-left: 5px; float: left">Incubation</b>
                        </div>
                            </div>
                        <%--<table width="100%" frame="box">
                            <tr>
                                <td style="color: maroon"><b>Entry Type:</b></td>
                                <td>
                                    <asp:DropDownList ID="ddltype" runat="server" Width="132">
                                        <asp:ListItem Value="Microscopic">Microscopy</asp:ListItem>
                                        <asp:ListItem Value="Plating">Plating</asp:ListItem>
                                        <asp:ListItem Value="Incubation">Incubation</asp:ListItem>
                                        <asp:ListItem Value="ALL">ALL</asp:ListItem>
                                    </asp:DropDownList></td>
                                <td></td>
                                <td></td>
                            </tr>
                            <tr>
                                <td style="color: maroon"><b>From Date:</b></td>
                                <td>
                                    <asp:TextBox ID="dtFrom" runat="server" ReadOnly="true" Width="128px"></asp:TextBox>

                                    <cc1:CalendarExtender runat="server" ID="ce_dtfrom"
                                        TargetControlID="dtFrom"
                                        Format="dd-MMM-yyyy"
                                        PopupButtonID="dtFrom" />
                                </td>
                                <td style="color: maroon"><b>To Date:</b></td>
                                <td>
                                    <asp:TextBox ID="dtTo" runat="server" ReadOnly="true" Width="128px"></asp:TextBox>
                                    <cc1:CalendarExtender runat="server" ID="ce_dtTo"
                                        TargetControlID="dtTo"
                                        Format="dd-MMM-yyyy"
                                        PopupButtonID="dtTo" />
                                </td>
                            </tr>
                            <tr>
                                <td style="color: maroon"><b>UHID No.:</b> </td>
                                <td>
                                    <asp:TextBox ID="txtvisitno" runat="server" Width="128"></asp:TextBox></td>
                                <td style="color: maroon"><b>Barcode No.:</b> </td>
                                <td>
                                    <asp:TextBox ID="txtsinno" runat="server" Width="128"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td style="color: maroon; text-align: center;" colspan="4">
                                    <input id="btnSearch" type="button" value="Search" onclick="searchdata('')" />
                                </td>
                            </tr>
                            <tr>
                                <td style="color: maroon; text-align: center;" colspan="4">
                                    <table>
                                        <tr>
                                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: lightyellow;" class="circle" onclick="searchdata('Pending')"></button>
                                            <b style="margin-top: 5px; margin-left: 5px; float: left">Pending</b>
                                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: pink;" class="circle" onclick="searchdata('Microscopic')"></button>
                                            <b style="margin-top: 5px; margin-left: 5px; float: left">Microscopic</b>
                                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: lightgreen;" class="circle" onclick="searchdata('Plating')"></button>
                                            <b style="margin-top: 5px; margin-left: 5px; float: left">Plating</b>
                                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: #00FFFF;" class="circle" onclick="searchdata('Plating')"></button>
                                            <b style="margin-top: 5px; margin-left: 5px; float: left">Incubation</b>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>--%>

                        <div class="Purchaseheader">
                            Search Result&nbsp;&nbsp;&nbsp; <span style="color: red;">Total Patient:</span>
                            <asp:Label ID="lblTotalPatient" Text="0" runat="server" Font-Bold="true" ForeColor="Red"></asp:Label>
                        </div>
                        <div id="PatientLabSearchOutput" style="height: 346px; overflow: scroll;">
                            <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdLabSearch" width="100%">
                                <tr id="trheader">
                                    <th class="GridViewHeaderStyle" scope="col" align="left">S.No</th>
                                    <th class="GridViewHeaderStyle" scope="col" align="left">UHID</th>
                                    <th class="GridViewHeaderStyle" scope="col" align="left">Barcode No.</th>
                                    <th class="GridViewHeaderStyle" scope="col" align="left">Patient Name</th>
                                    <th class="GridViewHeaderStyle" scope="col" align="left">Test Name</th>
                                </tr>
                            </table>
                        </div>
                    </td>
                    <td width="50%" valign="top">
                         <div   style="color: maroon;border:1px solid black;" >
                        <div class="row">
                            <div class="col-md-6">
                                <label class="pull-left"><b>Patient Name</b></label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-6">
                               <span id="Patinetname"></span>
                                    <span id="sptestid" style="display: none"></span>
                            </div>
                               <div class="col-md-6">
                                    <label class="pull-left">
                                        <b>Age</b>
                                    </label>
                                <b class="pull-right">:</b>
                               </div>
                            <div class="col-md-6">
                                   <span id="Age"></span>
                            </div>
                        </div>
                         <div class="row">
                            <div class="col-md-6">
                                <label class="pull-left"><b>Gender</b></label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-6">
                                <span id="Gender"></span>
                            </div>
                               <div class="col-md-6">
                                    <label class="pull-left">
                                        <b>UHID </b>
                                    </label>
                                <b class="pull-right">:</b>
                               </div>
                            <div class="col-md-6">
                                  <span id="VisitNo"></span>
                            </div>
                        </div>
                         <div class="row">
                            <div class="col-md-6">
                                <label class="pull-left"><b>Barcode No.</b></label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-6">
                                 <span id="SINNo"></span>
                            </div>
                               <div class="col-md-6">
                                    <label class="pull-left">
                                        <b>Test Name</b>
                                    </label>
                                <b class="pull-right">:</b>
                               </div>
                            <div class="col-md-6">
                                 <span id="TestName"></span>
                            </div>
                        </div> 
                              <div class="row">
                            <div class="col-md-6">
                                <label class="pull-left"><b>Sample Type</b></label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-6">
                                 <span id="SampleType"></span>
                            </div>
                               <div class="col-md-6">
                                    <label class="pull-left">
                                        <b>Sample Col. Date</b>
                                    </label>
                                <b class="pull-right">:</b>
                               </div>
                            <div class="col-md-6">
                                 <span id="SCDate"></span>
                            </div>
                        </div> 
                              <div class="row">
                            <div class="col-md-6">
                                <label class="pull-left"><b>Sample Rec. Date</b></label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-6">
                              <span id="SRDate"></span>
                            </div>
                               <div class="col-md-6">
                                    <label class="pull-left">
                                        <b>Status</b>
                                    </label>
                                <b class="pull-right">:</b>
                               </div>
                            <div class="col-md-6">
                               <span id="Status"></span>
                            </div>
                        </div> 
                              <div class="row">
                            <div class="col-md-6">
                                <label class="pull-left"><b>Last Status Date</b></label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-6">
                            <span id="StatusDate"></span>
                            </div>
                               <div class="col-md-6">
                                    <label class="pull-left">
                                        <b></b>
                                    </label>
                                <b class="pull-right"></b>
                               </div>
                            <div class="col-md-6">
                            </div>
                        </div> 

                            </div>
                       <%-- <table style="width: 100%" frame="box">
                            <tr>
                                <td style="color: maroon"><strong>Patient Name:</strong></td>
                                <td style="width: 170px; font-weight: bold" colspan="3"><span id="Patinetname"></span>
                                    <span id="sptestid" style="display: none"></span>
                                </td>

                            </tr>
                            <tr>
                                <td style="color: maroon"><strong>Age:</strong></td>
                                <td style="width: 170px; font-weight: bold"><span id="Age"></span></td>
                                <td style="color: maroon"><strong>Gender:</strong></td>
                                <td style="width: 170px; font-weight: bold"><span id="Gender"></span></td>

                            </tr>

                            <tr>
                                <td style="color: maroon; font-weight: 700;">UHID :</td>
                                <td style="width: 170px; font-weight: bold"><span id="VisitNo"></span></td>
                                <td style="color: maroon; font-weight: 700;">Barcode No.:</td>
                                <td style="width: 170px; font-weight: bold"><span id="SINNo"></span></td>

                            </tr>

                            <tr>
                                <td style="color: maroon"><strong>Test Name:</strong></td>
                                <td style="width: 170px; font-weight: bold" colspan="3"><span id="TestName"></span></td>

                            </tr>

                            <tr>
                                <td style="color: maroon"><strong>Sample Type:</strong></td>
                                <td style="width: 170px; font-weight: bold" colspan="3"><span id="SampleType"></span></td>

                            </tr>
                            <tr>
                                <td style="color: maroon"><strong>Sample Col. Date:</strong></td>
                                <td style="width: 170px; font-weight: bold"><span id="SCDate"></span></td>
                                <td style="color: maroon"><strong>Sample Rec. Date:</strong></td>
                                <td style="width: 170px; font-weight: bold"><span id="SRDate"></span></td>

                            </tr>
                            <tr>
                                <td style="color: maroon; font-weight: 700;">Status:</td>
                                <td style="width: 170px; font-weight: bold"><span id="Status"></span></td>
                                <td style="color: maroon; font-weight: 700;">Last Status Date:</td>
                                <td style="width: 170px; font-weight: bold"><span id="StatusDate"></span></td>

                            </tr>
                        </table>--%>

                        <div id="tableMicroScopic" style="display: none;">
                            <div class="Purchaseheader">MicroScopy Detail</div>
                            <table width="100%" frame="box">


                                <tr style="display: none;">
                                    <td style="font-weight: bold;">MicroScopy</td>

                                    <td>
                                        <asp:DropDownList ID="ddlmicroscopy" runat="server" Width="100">
                                            <asp:ListItem Value=""></asp:ListItem>
                                            <asp:ListItem Value="Wet Mount">Wet Mount</asp:ListItem>
                                            <asp:ListItem Value="Gram Stain">Gram Stain</asp:ListItem>
                                            <asp:ListItem Value="AFB">AFB Stain</asp:ListItem>
                                            <asp:ListItem Value="Other">Other</asp:ListItem>
                                        </asp:DropDownList></td>
                                </tr>

                                <tr style="display: none;">
                                    <td style="font-weight: bold;">Observation</td>
                                    <td>
                                        <asp:TextBox ID="txtcomment" runat="server" Width="400px" placeholder="Enter MicroScopy Comment" MaxLength="400"></asp:TextBox></td>
                                </tr>


                                <tr>
                                    <td colspan="2">

                                        <div style="width: 100%; height: 313px; overflow: auto;">


                                            <table style="width: 100%" cellspacing="0" id="tb_ItemList" class="GridViewStyle">
                                                <tr id="saheader" style="height: 20px;">
                                                    <th class="GridViewHeaderStyle" scope="col" style="width: 5%; text-align: left; font-size: 13px;">S.No.</th>
                                                    <th class="GridViewHeaderStyle" scope="col" style="width: 60%; text-align: left; font-size: 13px;">Observation</th>
                                                    <th class="GridViewHeaderStyle" scope="col" style="width: 20%; text-align: left; font-size: 13px;">Value</th>
                                                    <th class="GridViewHeaderStyle" scope="col" style="width: 15%; text-align: left; font-size: 13px;">Unit</th>




                                                </tr>
                                            </table>
                                        </div>
                                    </td>
                                </tr>

                                <tr>
                                    <td align="center" colspan="2">
                                        <input id="btnsavemic" type="button" value="Save" class="savebutton" onclick="savemicdata()" />
                                    </td>
                                </tr>
                            </table>

                        </div>


                        <div id="tablePlating" style="display: none;">
                            <div class="Purchaseheader">Plating Detail</div>
                            <table width="100%" frame="box">
                                <tr>
                                    <td style="font-weight: bold;">Comment:&nbsp;&nbsp;&nbsp;
                                 <asp:TextBox ID="txtplatecomment" runat="server" Width="400px" MaxLength="400" placeholder="Enter Plating Comment"></asp:TextBox>
                                    </td>
                                </tr>

                                <tr>
                                    <td style="font-weight: bold;">No of Plate:&nbsp; 
                             <asp:DropDownList ID="ddlnoofplate" runat="server" onchange="showplatenumber()" Width="50px">
                                 <asp:ListItem Value="0">0</asp:ListItem>
                                 <asp:ListItem Value="1">1</asp:ListItem>
                                 <asp:ListItem Value="2">2</asp:ListItem>
                                 <asp:ListItem Value="3">3</asp:ListItem>
                                 <asp:ListItem Value="4">4</asp:ListItem>
                             </asp:DropDownList></td>
                                </tr>
                                <tr>
                                    <td>
                                        <div style="height: 100px;">
                                            <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="platenumber">
                                                <tr id="phead">
                                                    <th class="GridViewHeaderStyle" scope="col" align="left" width="50px">Sr.No.</th>
                                                    <th class="GridViewHeaderStyle" scope="col" align="left" width="150px">Plate Number</th>
                                                </tr>
                                            </table>
                                        </div>
                                    </td>
                                </tr>

                                <tr>
                                    <td align="center">
                                        <input id="btnsavepating" type="button" value="Save" class="savebutton" onclick="saveplatdata()" />
                                    </td>
                                </tr>
                            </table>
                        </div>

                        <div id="tableincubation" style="display: none;">
                            <div class="Purchaseheader">Incubation Detail</div>
                            <table frame="box">
                                <tr>
                                    <td style="font-weight: bold;">Incubation Period:</td>
                                    <td>
                                        <asp:DropDownList ID="ddlIncubationperiod" runat="server" Width="100">
                                            <asp:ListItem Value=""></asp:ListItem>
                                            <asp:ListItem Value="12">12 Hours</asp:ListItem>
                                            <asp:ListItem Value="24">24 Hours</asp:ListItem>
                                            <asp:ListItem Value="48">48 Hours</asp:ListItem>
                                            <asp:ListItem Value="168">7 Days</asp:ListItem>
                                            <asp:ListItem Value="360">15 Days</asp:ListItem>
                                        </asp:DropDownList></td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">Batch/Rack No.:</td>
                                    <td>
                                        <asp:TextBox ID="txtbatch" runat="server"></asp:TextBox></td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">Incubation Comment:</td>
                                    <td>
                                        <asp:TextBox ID="txtinbcomment" runat="server" Width="400px" placeholder="Enter Incubation Comment" MaxLength="400"></asp:TextBox></td>
                                </tr>
                                <tr>
                                    <td align="center" colspan="2">
                                        <input id="btnIncubation" type="button" value="Save" class="savebutton" onclick="saveIncubation()" />
                                    </td>
                                </tr>

                            </table>
                        </div>

                        <div id="tableAll" style="display: none;">
                            <%----%>

                            <table width="100%">

                                <tr>
                                    <td width="59%" valign="top">
                                        <div class="Purchaseheader">MicroScopy</div>
                                        <table width="99%">
                                            <tr style="display: none;">


                                                <td>
                                                    <asp:DropDownList ID="ddlmicroscopysaveddata" runat="server" Width="100">

                                                        <asp:ListItem Value="Wet Mount">Wet Mount</asp:ListItem>
                                                        <asp:ListItem Value="Gram Stain">Gram Stain</asp:ListItem>
                                                        <asp:ListItem Value="AFB">AFB</asp:ListItem>
                                                        <asp:ListItem Value="Other">Other</asp:ListItem>
                                                    </asp:DropDownList>

                                                </td>
                                            </tr>
                                            <tr style="display: none;">

                                                <td>
                                                    <asp:TextBox ID="txtcommentsaved" runat="server" MaxLength="400"></asp:TextBox></td>
                                            </tr>
                                            <tr>
                                                <td>

                                                    <div style="width: 100%; height: 250px; overflow: auto;">


                                                        <table style="width: 100%" cellspacing="0" id="tb_ItemList1" class="GridViewStyle">
                                                            <tr id="saheader1" style="height: 20px;">
                                                                <th class="GridViewHeaderStyle" scope="col" style="width: 5%; text-align: left; font-size: 13px;">S.No.</th>
                                                                <th class="GridViewHeaderStyle" scope="col" style="width: 50%; text-align: left; font-size: 13px;">Observation</th>
                                                                <th class="GridViewHeaderStyle" scope="col" style="width: 30%; text-align: left; font-size: 13px;">Value</th>
                                                                <th class="GridViewHeaderStyle" scope="col" style="width: 15%; text-align: left; font-size: 13px;">Unit</th>




                                                            </tr>
                                                        </table>
                                                    </div>
                                                </td>


                                            </tr>


                                        </table>
                                    </td>
                                    <td width="1%"></td>
                                    <td width="40%" valign="top">

                                        <div class="Purchaseheader">Plating</div>
                                        <table>
                                            <tr>
                                                <td style="font-weight: bold;">Comment:

                                    
                                           <asp:TextBox ID="txtplatecommentsaved" runat="server" Width="65%" MaxLength="400"></asp:TextBox>
                                                </td>
                                            </tr>



                                            <tr>
                                                <td style="font-weight: bold;">No of Plate:

                                     
                                          <asp:DropDownList ID="ddlnoofplatesaved" runat="server" onchange="showplatenumbersaved()" Width="50px">

                                              <asp:ListItem Value="1">1</asp:ListItem>
                                              <asp:ListItem Value="2">2</asp:ListItem>
                                              <asp:ListItem Value="3">3</asp:ListItem>
                                              <asp:ListItem Value="4">4</asp:ListItem>
                                          </asp:DropDownList>
                                                </td>
                                            </tr>

                                            <tr>
                                                <td>
                                                    <div style="height: 95px; overflow: auto;">
                                                        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="platenumbersaved">
                                                            <tr id="phead1">
                                                                <th class="GridViewHeaderStyle" scope="col" align="left" width="50px">Sr.No.</th>
                                                                <th class="GridViewHeaderStyle" scope="col" align="left" width="150px">Plate Number</th>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <div class="Purchaseheader">Incubation</div>
                                                </td>
                                            </tr>

                                            <tr>
                                                <td>
                                                    <b>Incubation Period:</b>
                                                    <asp:DropDownList ID="ddlIncubationperiodsaved" runat="server" Width="80">

                                                        <asp:ListItem Value="12">12 Hours</asp:ListItem>
                                                        <asp:ListItem Value="24">24 Hours</asp:ListItem>
                                                        <asp:ListItem Value="48">48 Hours</asp:ListItem>
                                                        <asp:ListItem Value="168">7 Days</asp:ListItem>
                                                        <asp:ListItem Value="360">15 Days</asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <b>Batch/Rank No:</b>
                                                    <asp:TextBox ID="txtbatchsaved" runat="server" Width="41%"></asp:TextBox>
                                                </td>
                                            </tr>

                                            <tr>
                                                <td>
                                                    <b>Comment:</b><asp:TextBox ID="txtinbcommentsaved" runat="server" Width="61%" placeholder="Enter Incubation Comment" MaxLength="400"></asp:TextBox>
                                                </td>
                                            </tr>








                                        </table>
                                    </td>
                                </tr>

                                <tr>
                                    <td colspan="3">
                                        <strong>MicroScopy Done By</strong>
                                        <strong>:</strong>

                                        <asp:Label ID="lbmdoneby" runat="server"></asp:Label>&nbsp;&nbsp;
                                        

                                    
                                           <strong style="    margin-left: 92px;">Done Date</strong>
                                        <strong>:</strong>

                                        <asp:Label ID="lbmdonedate" runat="server"></asp:Label>
                                    </td>


                                </tr>

                                <tr>
                                    <td colspan="3">
                                        <strong>Plating Done By</strong>
                                        <strong style="margin-left:32px;">:</strong>

                                        <asp:Label ID="lbpladoby" runat="server"></asp:Label>&nbsp;&nbsp;
                                         

                                    
                                          <strong style="    margin-left: 92px;">Done Date</strong>

                                        <strong>:</strong>
                                        <asp:Label ID="lbpladodate" runat="server"></asp:Label>
                                    </td>
                                </tr>

                                <tr>

                                    <td colspan="3">
                                        <strong>Incubation Done By</strong>
                                        <strong style="margin-left:3px;">:</strong>
                                        <asp:Label ID="lbinby" runat="server"></asp:Label>&nbsp;&nbsp;
                                         <strong style="    margin-left: 92px;">Done Date</strong>

                                        <strong>:</strong>
                                        <asp:Label ID="lbindate" runat="server"></asp:Label>
                                    </td>
                                </tr>

                                <tr>
                                    <td colspan="3" align="center">
                                        <input id="btnupdatealldate" type="button" value="Update" class="savebutton" onclick="updatealldata()" />
                                    </td>
                                </tr>

                            </table>

                        </div>
                    </td>

                </tr>
            </table>
        </div>
    </div> 
     <select size="4" style="position: absolute; max-height: 100px; overflow: auto; display: none; width: 200px; height: 200px" class="helpselect" onkeyup="addtotext1(this,event)" ondblclick="addtotext(this)">
     </select>

    <%-- Search and View data--%>
    <script type="text/javascript">
        var mouseX;
        var mouseY;
        $(document).mousemove(function (e) {
            mouseX = e.pageX;
            mouseY = e.pageY;
        });


        function addtotext(obj) {

            var id = $(obj).attr("id");
            var mm = id.split('_')[1];
            $('.' + mm).val($(obj).val());
            $('.' + mm).focus();

            $('.helpselect').hide();
            $('.helpselect').removeAttr("id");
        }

        function addtotext1(obj, event) {
            if (event.keyCode == 13) {
                var id = $(obj).attr("id");
                var mm = id.split('_')[1];
                $('.' + mm).val($(obj).val());
                $('.' + mm).focus();

                $('.helpselect').hide();
                $('.helpselect').removeAttr("id");
            }
        }



        function _showhideList(help, ctr) {


            if ($('.helpselect').css('display') == 'none') {

                var ddlDoctor = $(".helpselect");
                $(".helpselect option").remove();

                for (i = 0; i < help.split('|').length; i++) {

                    ddlDoctor.append($("<option></option>").val(help.split('|')[i]).html(help.split('|')[i]));
                }


                $('.helpselect').css({ 'top': parseInt(mouseY) + 16, 'left': parseInt(mouseX) - 100 }).show();
                $('.helpselect').attr("id", "help_" + ctr);
                $('.helpselect :first-child').attr('selected', true);
            } else {
                $(".helpselect option").remove();
                $('.helpselect').hide();
                $('.helpselect').removeAttr("id");
                $('.helpselect').prop('selectedIndex', 0);
            }

        }
        function searchdata(type) {
            $('#btnSearch').attr('disabled', 'disabled').val('Searching...');
            $('#tb_grdLabSearch tr').slice(1).remove();
            var searchdata = searchingvalues(type);
            clearform();
           // $.blockUI();
            $.ajax({
                url: "MicroLabEntry.aspx/SearchData",
                data: JSON.stringify({ searchdata: searchdata }),
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",

                success: function (result) {
                    TestData = $.parseJSON(result.d);
                    if (TestData == "-1") {
                       // $.unblockUI();
                        $('#btnSearch').removeAttr('disabled').val('Search');
                        modelAlert("Your Session Has Been Expired! Please Login Again");
                        return;
                    }
                    if (TestData.length == 0) {
                        $('#<%=lblTotalPatient.ClientID%>').html('0');

                     }
                     else {
                         $('#<%=lblTotalPatient.ClientID%>').text(TestData.length);
                         for (var i = 0; i <= TestData.length - 1; i++) {
                             var mydata = "<tr onclick='showdetail(this)' title='Please Click To Proceed' id='" + TestData[i].Test_ID + "'  style='cursor:pointer;background-color:" + TestData[i].rowcolor + ";height:25px;'>";
                             mydata += '<td class="GridViewLabItemStyle" style="font-weight:bold;">' + parseInt(i + 1) + '</td>';
                             mydata += '<td class="GridViewLabItemStyle" style="font-weight:bold;display:none" id="trlabno" >' + TestData[i].LedgerTransactionNo + '</td>';
                             mydata += '<td class="GridViewLabItemStyle" style="font-weight:bold;" id="trPatientID" >' + TestData[i].PatientID + '</td>';
                             mydata += '<td class="GridViewLabItemStyle" style="font-weight:bold;" id="trbarcodeno">' + TestData[i].BarcodeNo + '</td>';
                             mydata += '<td class="GridViewLabItemStyle" id="trpname">' + TestData[i].PName + '</td>';
                             mydata += '<td class="GridViewLabItemStyle" id="trtestname">' + TestData[i].Name + '</td>';
                             mydata += '<td style="display:none;" id="trSampleTypeName">' + TestData[i].SampleTypeName + '</td>';
                             mydata += '<td style="display:none;" id="trAge">' + TestData[i].Age + '</td>';
                             mydata += '<td style="display:none;" id="trGender">' + TestData[i].Gender + '</td>';
                             mydata += '<td style="display:none;" id="trSampleCollectionDate">' + TestData[i].SampleCollectionDate + '</td>';
                             mydata += '<td style="display:none;" id="trSampleReceiveDate">' + TestData[i].SampleReceiveDate + '</td>';
                             mydata += '<td style="display:none;" id="trCultureStatusDate">' + TestData[i].CultureStatusDate + '</td>';
                             mydata += '<td style="display:none;" id="trCultureStatus">' + TestData[i].CultureStatus + '</td>';
                             mydata += '<td style="display:none;" id="trreportstatus">' + TestData[i].reportstatus + '</td>';

                             mydata += '<td style="display:none;" id="Investigation_ID">' + TestData[i].Investigation_ID + '</td>';
                             mydata += '<td style="display:none;" id="AgeInDays">' + TestData[i].AgeInDays + '</td>';

                             mydata += "</tr>";
                             $('#tb_grdLabSearch').append(mydata);

                         }

                     }
                     $('#btnSearch').removeAttr('disabled').val('Search');
                 //    $.unblockUI();

                 },
                 error: function (xhr, status) {
                     $('#btnSearch').removeAttr('disabled').val('Search');

                 }
             });
         }



         function searchingvalues(type) {

             var dataPLO = new Array();
             dataPLO[0] = $('#<%=ddltype.ClientID%>').val();
                  dataPLO[1] = $('#<%=dtFrom.ClientID%>').val();
                  dataPLO[2] = $('#<%=dtTo.ClientID%>').val();
                  dataPLO[3] = $('#<%=txtvisitno.ClientID%>').val();
                  dataPLO[4] = $('#<%=txtsinno.ClientID%>').val();
                  dataPLO[5] = type;
                  return dataPLO;
              }
              var control = "";

              function showdetail(ctrl) {
                  control = ctrl;
                  $('#Patinetname').html($(ctrl).find('#trpname').html());
                  $('#Age').html($(ctrl).find('#trAge').html());
                  $('#TestName').html($(ctrl).find('#trtestname').html());
                  $('#SCDate').html($(ctrl).find('#trSampleCollectionDate').html());
                  $('#SRDate').html($(ctrl).find('#trSampleReceiveDate').html());
                  $('#SampleType').html($(ctrl).find('#trSampleTypeName').html());
                  $('#Gender').html($(ctrl).find('#trGender').html());
                  $('#Status').html($(ctrl).find('#trCultureStatus').html());
                  $('#StatusDate').html($(ctrl).find('#trCultureStatusDate').html());
                  $('#VisitNo').html($(ctrl).find('#trPatientID').html());
                  $('#SINNo').html($(ctrl).find('#trbarcodeno').html());
                  $('#sptestid').html($(ctrl).attr("id"));

                  if ($(ctrl).find('#trCultureStatus').html() == "") {
                      $('#tableMicroScopic').show();
                      $('#tablePlating').hide();
                      $('#tableincubation').hide();
                      $('#tableAll').hide();

                      getMicroScopyData($(ctrl).find('#Investigation_ID').html(), $(ctrl).find('#trlabno').html(), $(ctrl).find('#trbarcodeno').html(), $(ctrl).find('#trGender').html(), $(ctrl).find('#AgeInDays').html(), $(ctrl).attr("id"));
                  }
                  else if ($(ctrl).find('#trCultureStatus').html() == "Microscopic") {
                      $('#tableMicroScopic').hide();
                      $('#tablePlating').show();
                      $('#tableincubation').hide();
                      $('#tableAll').hide();
                  }
                  else if ($(ctrl).find('#trCultureStatus').html() == "Plating") {
                      $('#tableMicroScopic').hide();
                      $('#tablePlating').hide();
                      $('#tableincubation').show();
                      $('#tableAll').hide();
                  }
                  else if ($(ctrl).find('#trCultureStatus').html() == "Incubation") {
                      getsaveddata();


                      getMicroScopyDataaftersaved($(ctrl).find('#Investigation_ID').html(), $(ctrl).find('#trlabno').html(), $(ctrl).find('#trbarcodeno').html(), $(ctrl).find('#trGender').html(), $(ctrl).find('#AgeInDays').html(), $(ctrl).attr("id"));


                      $('#tableMicroScopic').hide();
                      $('#tablePlating').hide();
                      $('#tableincubation').hide();
                      $('#tableAll').show();
                      if ($(ctrl).find('#trreportstatus').html() == "saved") {
                          $('#btnupdatealldate').hide();
                      }
                      else {
                          $('#btnupdatealldate').show();
                      }

                  }
              }



              function getMicroScopyData(invid, labno, barcodeno, Gender, AgeInDays, testid) {
                  $('#tb_ItemList tr').slice(1).remove();
                  $.ajax({
                      url: "MicroLabEntry.aspx/getMicroScopyData",
                      data: '{invid:"' + invid + '",LabNo:"' + labno + '",barcodeno:"' + barcodeno + '",Gender:"' + Gender + '",AgeInDays:"' + AgeInDays + '",Test_id:"' + testid + '"}',
                      type: "POST",
                      contentType: "application/json; charset=utf-8",
                      timeout: 120000,
                      dataType: "json",

                      success: function (result) {

                          ObsData = $.parseJSON(result.d);
                          var a = 1;
                          for (var i = 0; i <= ObsData.length - 1; i++) {

                              var mydata = "";
                              if (ObsData[i].MICROSCOPY == "1") {
                                  mydata = "<tr style='background-color:lightyellow;height:25px;'>";
                                  mydata += '<td class="GridViewLabItemStyle">' + a + '</td>';

                                  if (ObsData[i].value == 'HEAD') {
                                      mydata += '<td class="GridViewLabItemStyle" id="labObservationName" style="font-weight:bold;font-size:13px;" >' + ObsData[i].labObservationName + '</td>';
                                      mydata += '<td class="GridViewLabItemStyle" id="value"><input id="txtvalue" style="font-weight:bold;color:green;border:0px;font-style:italic;font-size:13px;background-color:lightyellow;" type="text" value=' + ObsData[i].value + ' readonly="true" autocomplete="off" /></td>';
                                      mydata += '<td class="GridViewLabItemStyle" id="Unit"><input type="text" id="txtunit" value="" style="display:none;" /></td>';
                                  }
                                  else {
                                      mydata += '<td class="GridViewLabItemStyle" id="labObservationName" style="font-weight:bold;padding-left:20px;font-size:12px;" >' + ObsData[i].labObservationName + '</td>';
                                      mydata += '<td class="GridViewLabItemStyle" id="value"><input id="txtvalue"  autocomplete="off" type="text" onkeyup="if(event.keyCode==13){_showhideList(\'' + ObsData[i].help + '\',\'' + ObsData[i].labObservation_ID + '\')"};" value="" style="width:80%" class=' + ObsData[i].labObservation_ID + ' />';

                                      if (ObsData[i].help != "") {
                                          mydata += '<img id="imghelp" onclick="_showhideList(\'' + ObsData[i].help + '\',\'' + ObsData[i].labObservation_ID + '\')" src="../../Images/question_blue.png" />';
                                      }

                                      mydata += '</td>';
                                      mydata += '<td class="GridViewLabItemStyle" id="Unit"><input type="text" id="txtunit" style="width:80%"  value="' + ObsData[i].Unit + '" /></td>';
                                  }



                                  mydata += '<td style="display:none;" id="labObservation_ID">' + ObsData[i].labObservation_ID + '</td>';

                                  mydata += "</tr>";
                                  a++;
                              }
                              else {
                                  mydata = "<tr style='display:none;'>";
                                  mydata += '<td class="GridViewLabItemStyle">' + parseInt(i + 1) + '</td>';
                                  mydata += '<td class="GridViewLabItemStyle" id="labObservationName" >' + ObsData[i].labObservationName + '</td>';
                                  mydata += '<td class="GridViewLabItemStyle" id="value"><input id="txtvalue" type="text" value="" style="width:80%"  autocomplete="off" />';
                                  mydata += '<td class="GridViewLabItemStyle" id="Unit"><input type="text" id="txtunit" style="width:80%"   /></td>';
                                  mydata += '<td  id="labObservation_ID">' + ObsData[i].labObservation_ID + '</td>';

                              }
                              $('#tb_ItemList').append(mydata);

                          }


                      },
                      error: function (xhr, status) {
                          $('#btnsavemic').removeAttr('disabled').val('Save');

                      }
                  });
              }



              function clearform() {
                  $('#Patinetname').html('');
                  $('#Age').html('');
                  $('#TestName').html('');
                  $('#SCDate').html('');
                  $('#SRDate').html('');
                  $('#SampleType').html('');
                  $('#Gender').html('');
                  $('#Status').html('');
                  $('#StatusDate').html('');
                  $('#VisitNo').html('');
                  $('#SINNo').html('');
                  $('#sptestid').html('');
                  $('#tableMicroScopic').hide();
                  $('#tablePlating').hide();
                  $('#tableincubation').hide();
                  $('#tableAll').hide();

                  clearformcontrol();

              }

              function clearformcontrol() {
                  $('#platenumber tr').slice(1).remove();

                  $('#<%=txtbatch.ClientID%>').val('');
                  $('#<%=txtbatchsaved.ClientID%>').val('');

                  $('#<%=txtcomment.ClientID%>').val('');
                  $('#<%=txtcommentsaved.ClientID%>').val('');

                  $('#<%=txtplatecomment.ClientID%>').val('');
                  $('#<%=txtplatecommentsaved.ClientID%>').val('');

                  $('#<%=txtinbcomment.ClientID%>').val('');
                  $('#<%=txtinbcommentsaved.ClientID%>').val('');

                  $('#<%=ddlIncubationperiod.ClientID%>,#<%=ddlIncubationperiodsaved.ClientID%>,#<%=ddlmicroscopy.ClientID%>,#<%=ddlmicroscopysaveddata.ClientID%>,#<%=ddlnoofplate.ClientID%>,#<%=ddlnoofplatesaved.ClientID%>').prop('selectedIndex', 0);
              }
    </script>

    <%-- MicroScopic Data Save--%>
    <script type="text/javascript">
        function savemicdata() {
            var datatosave = datatosavemicroscopy();
            $('#btnsavemic').attr('disabled', 'disabled').val('Saving...');
            $.ajax({
                url: "MicroLabEntry.aspx/SaveMicroScopicdata",
                data: JSON.stringify({ datatosave: datatosave }),
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",

                success: function (result) {
                    TestData = result.d;
                    if (TestData == "-1") {
                    //    $.unblockUI();
                        $('#btnsavemic').removeAttr('disabled').val('Save');
                        modelAlert("Your Session Has Been Expired! Please Login Again");
                        return;
                    }
                    $('#btnsavemic').removeAttr('disabled').val('Save');
                    if (TestData == "1") {
                        //modelAlert("MicroScopic Record Saved Successfully", function () { MicroScopic Record Saved Successfully
                        modelAlert("Microscopic Saved Successfully", function () {
                            $('#tableMicroScopic').hide();
                            $('#tablePlating').show();
                            $('#tableincubation').hide();
                            $('#tableAll').hide();
                            clearformcontrol();
                        });
                    }
                    else {
                        modelAlert(TestData)
                    }
                },
                error: function (xhr, status) {
                    $('#btnsavemic').removeAttr('disabled').val('Save');

                }
            });
        }

        function datatosavemic() {
            var dataPLO = new Array();
            dataPLO[0] = $('#sptestid').html();
            dataPLO[1] = $('#VisitNo').html();
            dataPLO[2] = $('#SINNo').html();
            dataPLO[3] = $('#<%=ddlmicroscopy.ClientID%>').val();
                  dataPLO[4] = $('#<%=txtcomment.ClientID%>').val();
                  return dataPLO;
              }

              function datatosavemicroscopy() {
                  var dataantibiotic = new Array();
                  $('#tb_ItemList tr').each(function () {
                      var id = $(this).closest("tr").attr("id");
                      if (id != "saheader") {
                          var plo = new Object();
                          plo.Test_ID = $('#sptestid').html();
                          plo.LabObservation_ID = $(this).closest("tr").find('#labObservation_ID').html();
                          plo.LabObservationName = $(this).closest("tr").find('#labObservationName').html();
                          plo.Value = $(this).closest("tr").find('#txtvalue').val();
                          plo.ReadingFormat = $(this).closest("tr").find('#txtunit').val();
                          plo.Reporttype = "Preliminary 1";
                          plo.LedgerTransactionNo = $('#VisitNo').html();
                          plo.BarcodeNo = $('#SINNo').html();
                          dataantibiotic.push(plo);
                      }
                  });
                  return dataantibiotic;
              }
    </script>


    <%-- Plating Data Save--%>
    <script type="text/javascript">
        function showplatenumber() {
            $('#platenumber tr').slice(1).remove();
            for (var a = 1; a <= $('#<%=ddlnoofplate.ClientID%>').val() ; a++) {
                   var mydata = "<tr id='" + a + "'  style='cursor:pointer;background-color:lightgreen;height:25px;'>";
                   mydata += '<td class="GridViewLabItemStyle"  width="50px">' + a + '</td>';
                   mydata += '<td class="GridViewLabItemStyle" width="150px"><input class="plno" type="text" style="width:150px"/></td>';
                   mydata += "</tr>";
                   $('#platenumber').append(mydata);
               }
           }

           function saveplatdata() {
               if ($('#<%=ddlnoofplate.ClientID%>').val() == "0") {
                      modelAlert("Please Select No of Plat ");
                      $('#<%=ddlnoofplate.ClientID%>').focus();
                      return;
                  }


                  var sn = 0;
                  $('#platenumber tr').each(function () {
                      if ($(this).attr("id") != "phead") {
                          var plno = $(this).find('.plno').val().trim();
                          if (plno == "") {
                              sn = 1;
                              $(this).find('.plno').focus();
                              return false;
                          }
                      }
                  });

                  if (sn == 1) {
                      modelAlert("Please Enter Plate Number ");
                      return false;
                  }


                  var datatosave = datatosaveplate();
                  $('#btnsavepating').attr('disabled', 'disabled').val('Saving...');
                  $.ajax({
                      url: "MicroLabEntry.aspx/SavePlatingdata",
                      data: JSON.stringify({ datatosave: datatosave }),
                      type: "POST",
                      contentType: "application/json; charset=utf-8",
                      timeout: 120000,
                      dataType: "json",

                      success: function (result) {
                          TestData = result.d;
                          if (TestData == "-1") {
                            //  $.unblockUI();
                              $('#btnsavepating').removeAttr('disabled').val('Save');
                              modelAlert("Your Session Has Been Expired! Please Login Again");
                              return;
                          }
                          $('#btnsavepating').removeAttr('disabled').val('Save');
                          if (TestData == "1") {
                              modelAlert("Plating Saved Successfully", function () {
                                  $('#tableMicroScopic').hide();
                                  $('#tablePlating').hide();
                                  $('#tableincubation').show();
                                  $('#tableAll').hide();
                                  clearformcontrol();
                              });
                          }
                          else {
                              modelAlert(TestData);
                          }
                      },
                      error: function (xhr, status) {
                          $('#btnsavepating').removeAttr('disabled').val('Save');
                      }
                  });
              }
              function datatosaveplate() {
                  var dataPLO = new Array();
                  dataPLO[0] = $('#sptestid').html();
                  dataPLO[1] = $('#VisitNo').html();
                  dataPLO[2] = $('#SINNo').html();
                  dataPLO[3] = $('#<%=ddlnoofplate.ClientID%>').val();
                  dataPLO[4] = $('#<%=txtplatecomment.ClientID%>').val();
                  var platenumber = "";
                  $('#platenumber tr').each(function () {
                      if ($(this).attr("id") != "phead") {
                          platenumber += $(this).find('.plno').val().trim() + "#";
                      }
                  });
                  dataPLO[5] = platenumber;
                  return dataPLO;
              }
    </script>



    <%-- Incubation Data Save--%>
    <script type="text/javascript">
        function saveIncubation() {
            if ($('#<%=ddlIncubationperiod.ClientID%>').val() == "") {
                   modelAlert("Please Select Incubation Period ");
                   $('#<%=ddlIncubationperiod.ClientID%>').focus();
                   return;
               }
               var datatosave = datatosaveincu();
               $('#btnIncubation').attr('disabled', 'disabled').val('Saving...');
               $.ajax({
                   url: "MicroLabEntry.aspx/SaveIncubationdata",
                   data: JSON.stringify({ datatosave: datatosave }),
                   type: "POST",
                   contentType: "application/json; charset=utf-8",
                   timeout: 120000,
                   dataType: "json",
                   success: function (result) {
                       TestData = result.d;
                       if (TestData == "-1") {
                         //  $.unblockUI();
                           $('#btnIncubation').removeAttr('disabled').val('Save');
                           modelAlert("Your Session Has Been Expired! Please Login Again");
                           return;
                       }
                       $('#btnIncubation').removeAttr('disabled').val('Save');
                       if (TestData == "1") {
                           //modelAlert("Incubation Record Saved Successfully", function () {
                           modelAlert("Incubation Saved Successfully", function () {
                               $('#tableMicroScopic').hide();
                               $('#tablePlating').hide();
                               $('#tableincubation').hide();
                               clearformcontrol();
                               getsaveddata();
                               getMicroScopyDataaftersaved($(control).find('#Investigation_ID').html(), $(control).find('#trlabno').html(), $(control).find('#trbarcodeno').html(), $(control).find('#trGender').html(), $(control).find('#AgeInDays').html(), $(control).attr("id"));
                               $('#tableAll').show();
                           });
                       }
                       else {
                           modelAlert(TestData);
                       }
                   },
                   error: function (xhr, status) {
                       $('#btnIncubation').removeAttr('disabled').val('Save');
                   }
               });
           }

           function datatosaveincu() {
               var dataPLO = new Array();
               dataPLO[0] = $('#sptestid').html();
               dataPLO[1] = $('#VisitNo').html();
               dataPLO[2] = $('#SINNo').html();
               dataPLO[3] = $('#<%=ddlIncubationperiod.ClientID%>').val();
               dataPLO[4] = $('#<%=txtbatch.ClientID%>').val();
               dataPLO[5] = $('#<%=txtinbcomment.ClientID%>').val();
               return dataPLO;
           }
    </script>


    <%-- OLD Data Search and Update--%>
    <script type="text/javascript">
        function getsaveddata() {
            $.ajax({
                url: "MicroLabEntry.aspx/GetSavedData",
                data: '{testid:"' + $('#sptestid').html() + '"}', // parameter map 
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    TestData = $.parseJSON(result.d);
                    if (TestData.length > 0) {
                        $('#ContentPlaceHolder1_ddlmicroscopysaveddata').val(TestData[0].MicroScopic);
                        $('#ContentPlaceHolder1_txtcommentsaved').val(TestData[0].MicroScopicComment);
                        $('#ContentPlaceHolder1_txtplatecommentsaved').val(TestData[0].PlatingComment);
                        $('#ContentPlaceHolder1_ddlnoofplatesaved').val(TestData[0].NoofPlate);
                        $('#<%=lbmdoneby.ClientID%>').text(TestData[0].MicroScopicDoneBy);
                              $('#<%=lbmdonedate.ClientID%>').text(TestData[0].MicroScopicDate);
                              $('#<%=lbpladoby.ClientID%>').text(TestData[0].PlatingDoneBy);
                              $('#<%=lbpladodate.ClientID%>').text(TestData[0].PlatingDate);
                              $('#<%=lbinby.ClientID%>').text(TestData[0].IncubationDoneBy);
                              $('#<%=lbindate.ClientID%>').text(TestData[0].IncubationDate);
                              $('#<%=txtinbcommentsaved.ClientID%>').val(TestData[0].IncubationComment);
                              $('#<%=txtbatchsaved.ClientID%>').val(TestData[0].IncubationBatch);
                              $('#<%=ddlIncubationperiodsaved.ClientID%>').val(TestData[0].IncubationPeriod);
                              $('#<%=txtplatecommentsaved.ClientID%>').val(TestData[0].PlatingComment);
                              $('#platenumbersaved tr').slice(1).remove();
                              for (var c = 0; c <= TestData[0].PlateNumber.split('#').length - 1 ; c++) {
                                  var mydata = "<tr id='" + parseInt(c + 1) + "'  style='cursor:pointer;background-color:lightgreen;height:25px;'>";
                                  mydata += '<td class="GridViewLabItemStyle"  width="50px">' + parseInt(c + 1) + '</td>';
                                  mydata += '<td class="GridViewLabItemStyle" width="150px"><input class="plno" type="text" style="width:150px" value="' + TestData[0].PlateNumber.split('#')[c] + '"/></td>';
                                  mydata += "</tr>";
                                  $('#platenumbersaved').append(mydata);
                              }
                          }
                      },
                      error: function (xhr, status) {
                          $('#btnsavemic').removeAttr('disabled').val('Search');
                      }
                  });
              }

              function getMicroScopyDataaftersaved(invid, labno, barcodeno, Gender, AgeInDays, testid) {
                  $.ajax({
                      url: "MicroLabEntry.aspx/getMicroScopyDataaftersave",
                      data: '{invid:"' + invid + '",LabNo:"' + labno + '",barcodeno:"' + barcodeno + '",Gender:"' + Gender + '",AgeInDays:"' + AgeInDays + '",Test_id:"' + testid + '"}',
                      type: "POST",
                      contentType: "application/json; charset=utf-8",
                      timeout: 120000,
                      dataType: "json",
                      success: function (result) {
                          ObsData = $.parseJSON(result.d);
                          var a = 1;
                          $('#tb_ItemList1 tr').slice(1).remove();
                          for (var i = 0; i <= ObsData.length - 1; i++) {
                              var mydata = "";
                              if (ObsData[i].MICROSCOPY == "1") {
                                  mydata = "<tr style='background-color:lightyellow;height:25px;'>";
                                  mydata += '<td class="GridViewLabItemStyle">' + a + '</td>';
                                  if (ObsData[i].value == 'HEAD') {
                                      mydata += '<td class="GridViewLabItemStyle" id="labObservationName" style="font-weight:bold;font-size:13px;" >' + ObsData[i].labObservationName + '</td>';
                                      mydata += '<td class="GridViewLabItemStyle" id="value"><input id="txtvalue" style="font-weight:bold;color:green;border:0px;font-style:italic;font-size:13px;background-color:lightyellow;width:65px;" type="text" value=' + ObsData[i].value + ' readonly="true"/></td>';
                                      mydata += '<td class="GridViewLabItemStyle" id="Unit"><input type="text" id="txtunit" value=""  style="display:none;width:40px;" /></td>';
                                  }
                                  else {
                                      mydata += '<td class="GridViewLabItemStyle" id="labObservationName" style="font-weight:bold;padding-left:10px;font-size:12px;" >' + ObsData[i].labObservationName + '</td>';
                                      mydata += '<td class="GridViewLabItemStyle" id="value"><input id="txtvalue" value="' + ObsData[i].value + '" type="text" value="" style="width:65px;" class=' + ObsData[i].labObservation_ID + ' />';

                                      if (ObsData[i].help != "") {
                                          mydata += '<img id="imghelp" onclick="_showhideList(\'' + ObsData[i].help + '\',\'' + ObsData[i].labObservation_ID + '\')" src="../../Images/question_blue.png" />';
                                      }
                                      mydata += '</td>';
                                      mydata += '<td class="GridViewLabItemStyle" id="Unit"><input type="text" id="txtunit" style="width:40px;"  value="' + ObsData[i].Unit + '" /></td>';
                                  }
                                  mydata += '<td style="display:none;" id="labObservation_ID">' + ObsData[i].labObservation_ID + '</td>';
                                  mydata += "</tr>";
                                  a++;
                              }
                              else {
                                  mydata = "<tr style='display:none;'>";
                                  mydata += '<td class="GridViewLabItemStyle">' + parseInt(i + 1) + '</td>';
                                  mydata += '<td class="GridViewLabItemStyle" id="labObservationName" >' + ObsData[i].labObservationName + '</td>';
                                  mydata += '<td class="GridViewLabItemStyle" id="value"><input id="txtvalue" type="text" value="" style="width:80%"  autocomplete="off" />';
                                  mydata += '<td class="GridViewLabItemStyle" id="Unit"><input type="text" id="txtunit" style="width:80%"   /></td>';
                                  mydata += '<td  id="labObservation_ID">' + ObsData[i].labObservation_ID + '</td>';
                              }
                              $('#tb_ItemList1').append(mydata);
                          }
                      },
                      error: function (xhr, status) {
                          $('#btnsavemic').removeAttr('disabled').val('Save');
                      }
                  });
              }



              function showplatenumbersaved() {
                  $('#platenumbersaved tr').slice(1).remove();
                  for (var a = 1; a <= $('#<%=ddlnoofplatesaved.ClientID%>').val() ; a++) {
                      var mydata = "<tr id='" + a + "'  style='cursor:pointer;background-color:lightgreen;height:25px;'>";
                      mydata += '<td class="GridViewLabItemStyle"  width="50px">' + a + '</td>';
                      mydata += '<td class="GridViewLabItemStyle" width="150px"><input class="plno" type="text" style="width:150px"/></td>';
                      mydata += "</tr>";
                      $('#platenumbersaved').append(mydata);
                  }
              }
              function datatosavemicroscopyaftersave() {
                  var dataantibiotic = new Array();
                  $('#tb_ItemList1 tr').each(function () {
                      var id = $(this).closest("tr").attr("id");
                      if (id != "saheader1") {
                          var plo = new Object();
                          plo.Test_ID = $('#sptestid').html();
                          plo.LabObservation_ID = $(this).closest("tr").find('#labObservation_ID').html();
                          plo.LabObservationName = $(this).closest("tr").find('#labObservationName').html();
                          plo.Value = $(this).closest("tr").find('#txtvalue').val();
                          plo.ReadingFormat = $(this).closest("tr").find('#txtunit').val();
                          plo.Reporttype = "Preliminary 1";
                          plo.LedgerTransactionNo = $('#VisitNo').html();
                          plo.BarcodeNo = $('#SINNo').html();
                          dataantibiotic.push(plo);
                      }
                  });
                  return dataantibiotic;
              }

              function updatealldata() {
                  var datatosave = datatosavemicroscopyaftersave();
                  if ($('#<%=ddlnoofplatesaved.ClientID%>').val() == "0") {
                      modelAlert("Please Select No of Plat");
                      $('#<%=ddlnoofplatesaved.ClientID%>').focus();
                      return;
                  }
                  var sn = 0;
                  $('#platenumbersaved tr').each(function () {
                      if ($(this).attr("id") != "phead1") {
                          var plno = $(this).find('.plno').val().trim();
                          if (plno == "") {
                              sn = 1;
                              $(this).find('.plno').focus();
                              return false;
                          }
                      }
                  });

                  if (sn == 1) {
                      modelAlert("Please Enter Plate Number");
                      return false;
                  }

                  var datatoupdate = getdatatoupdate();
                  $('#btnupdatealldate').attr('disabled', 'disabled').val('Updating...');
                  $.ajax({
                      url: "MicroLabEntry.aspx/UpdateAllData",
                      data: JSON.stringify({ datatoupdate: datatoupdate, datatosave: datatosave }),
                      type: "POST",
                      contentType: "application/json; charset=utf-8",
                      timeout: 120000,
                      dataType: "json",

                      success: function (result) {
                          TestData = result.d;
                          if (TestData == "-1") {
                            //  $.unblockUI();
                              $('#btnupdatealldate').removeAttr('disabled').val('Update');
                              modelAlert("Your Session Has Been Expired! Please Login Again");
                              return;
                          }
                          $('#btnupdatealldate').removeAttr('disabled').val('Update');
                          if (TestData == "1") {
                              modelAlert("Record Updated Successfully", function () {
                                  clearform();
                                  searchdata('');
                              });
                          }
                          else {
                              modelAlert(TestData);
                          }
                      },
                      error: function (xhr, status) {
                          $('#btnupdatealldate').removeAttr('disabled').val('Update');

                      }
                  });
              }

              function getdatatoupdate() {
                  var dataPLO = new Array();
                  dataPLO[0] = $('#sptestid').html();
                  dataPLO[1] = $('#<%=ddlmicroscopysaveddata.ClientID%>').val();
                  dataPLO[2] = $('#<%=txtcommentsaved.ClientID%>').val();
                  dataPLO[3] = $('#<%=ddlnoofplatesaved.ClientID%>').val();
                  dataPLO[4] = $('#<%=txtplatecommentsaved.ClientID%>').val();

                  var platenumber = "";
                  $('#platenumbersaved tr').each(function () {
                      if ($(this).attr("id") != "phead1") {
                          platenumber += $(this).find('.plno').val().trim() + "#";
                      }
                  });
                  dataPLO[5] = platenumber;
                  dataPLO[6] = $('#<%=ddlIncubationperiodsaved.ClientID%>').val();
                  dataPLO[7] = $('#<%=txtbatchsaved.ClientID%>').val();
                  dataPLO[8] = $('#<%=txtinbcommentsaved.ClientID%>').val();
                  return dataPLO;
              }
    </script>
</asp:Content>

