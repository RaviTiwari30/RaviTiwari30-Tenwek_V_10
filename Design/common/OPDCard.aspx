<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OPDCard.aspx.cs" StylesheetTheme="Theme1" Culture="auto" Inherits="Design_common_OPDCard" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>OPD CARD</title>
    <script language='VBScript' type="text/vbscript">

    Function Print()    
 
           OLECMDID_PRINT = 6
           OLECMDEXECOPT_DONTPROMPTUSER = 2
           OLECMDEXECOPT_PROMPTUSER = 1
           call WB.ExecWB(OLECMDID_PRINT, OLECMDEXECOPT_DONTPROMPTUSER,1)

 'window.close
    End Function
    document.write "<object ID='WB' WIDTH=0 HEIGHT=0 CLASSID='CLSID:8856F961-340A-11D0-A96B-00C04FD705A2'></object>"  
    </script>
    <link href="../../App_Themes/Theme1/mm.css" rel="stylesheet" type="text/css" />
    </head>

<body onload="vbscript:Print()" style="margin-left: 10px;margin-right:10px">

    <form id="form1" runat="server">
        <div>
            <table style="width: 722px;" >
                <tbody>
                <tr>
                    <td>
                        <table style="width: 730px;  border-collapse: collapse; height: 90px;" >
                            <tr>
                                <td style="text-align: center; width: 100%;" colspan="6">
                                    <table border="0" style="width: 100%; border-collapse: collapse">
                                        <tr>
                                            <td style="text-align: left; vertical-align: top">
                                                <asp:Label ID="lblHeaderText" runat="server"></asp:Label>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="6" style="width: 100%;height:20px;" align="right">    
                               
                                </td>
                            </tr>
                        </table>
                              
                        <table style="width: 100%; border-collapse: collapse;" >
                            <tr >
                                <td class="topbottom" colspan="8" style="width: 100%;">
                                        <asp:Label ID="Label1" runat="server" Text="OPD No. :" Font-Size="10pt" Font-Bold="true" ></asp:Label>
                                 
                                    <asp:Label ID="lblOPDVisitNo" runat="server" Font-Bold="true" Font-Size="10pt" ></asp:Label>
                                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                 

                                      <asp:Label ID="lblHeader" runat="server" Text="OPD CARD" Font-Bold="True"
                                        Font-Size="14pt" ></asp:Label>
                                       &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp;  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                     <asp:Label ID="lblToken" runat="server" Text="Token No. :" Font-Size="10pt" Font-Bold="true" ></asp:Label>
                                 
                                    <asp:Label ID="lblTokenNo" runat="server" Font-Bold="true" Font-Size="10pt" ></asp:Label>
                                </td>

                            </tr>
                             <tr style="font-size: 12pt" id="trNepDate"  visible="false" runat="server">
                                <td style="vertical-align: top; width: 10%; height: 14%">&nbsp;</td>
                                <td style="vertical-align: top; width: 2%; height: 14%">&nbsp;</td>
                                <td style="vertical-align: top; width: 38%; height: 14%">&nbsp;</td>
                                <td style="vertical-align: top; width: 10%; height: 14%">
                                    <asp:Label ID="lblNepDate" runat="server" Text="MITI"></asp:Label>
                                </td>
                                <td style="vertical-align: top; width: 2%; height: 14%">
                                    <strong style="font-size:10pt">:</strong>
                                </td>
                                <td style="vertical-align: top; width: 38%; height: 14%">
                                    <asp:Label ID="lblNepaliDate" runat="server" Font-Names="Verdana" Font-Size="8pt"  meta:resourcekey="lblNepaliDateResource1" ClientIDMode="Static"></asp:Label>
                                    
                                </td>
                                <td style="vertical-align:bottom; width: 38%; " rowspan="5">
                                       &nbsp;
                                </td>
                                 
                            </tr>
                            <tr style="font-size: 12pt">
                                <td style="vertical-align: top; width: 10%; height: 14%">
                                    <asp:Label ID="lblMrNo" Font-Size="10pt" Font-Names="Verdana" runat="server" Text="UHID" Width="100%" meta:resourcekey="lblMrNoResource1"></asp:Label>

                                </td>
                                <td style="vertical-align: top; width: 2%; height: 14%">
                                    <strong style="font-size:10pt">:</strong>
                                </td>
                                <td style="vertical-align: top; width: 38%; height: 14%">

                                    <asp:Label ID="LblRegNo"   runat="server" Font-Names="Verdana" Font-Size="10pt"
                                        meta:resourcekey="LblRegNoResource1"></asp:Label>
                                </td>
                                <td style="vertical-align: top; width: 10%; height: 14%">
                                    <asp:Label ID="lblDate1" runat="server" Font-Names="Verdana" Font-Size="10pt" Text="Date" meta:resourcekey="lblDate1Resource1"></asp:Label>
                                </td>
                                <td style="vertical-align: top; width: 2%; height: 14%">
                                    <strong style="font-size:10pt">:</strong>
                                </td>
                                <td style="vertical-align: top; width: 38%; height: 14%">
                                    <asp:Label ID="LblDate" runat="server" Font-Names="Verdana" Font-Size="10pt" meta:resourcekey="LblDateResource1"></asp:Label>&nbsp;<asp:Label
                                        ID="LblTime" runat="server" Font-Size="9pt" Font-Names="Verdana" meta:resourcekey="LblTimeResource1"></asp:Label>
                                </td>
                                <td style="vertical-align:bottom; width: 38%; " rowspan="4">
                                       <img id="imgPatient" runat="server"  style="height:30px;width:117px; display:none;" alt="Patient BarCode"/>
                                </td>
                            </tr>
                            <tr style="font-size: 12pt">
                                <td style="vertical-align: top; width: 10%; height: 14%">
                                    <asp:Label ID="lblName" runat="server" Font-Names="Verdana" Font-Size="10pt" Text="Name" meta:resourcekey="lblNameResource1"></asp:Label>

                                </td>
                                <td style="vertical-align: top; width: 2%; height: 14%">
                                    <strong style="font-size:10pt">:</strong>
                                </td>
                                <td style="vertical-align: top; width: 38%; height: 14%">
                                    <asp:Label ID="LblPatientName" runat="server"  Font-Names="Verdana" Font-Size="10pt"
                                        Font-Bold="true" meta:resourcekey="LblPatientNameResource1"></asp:Label>

                                </td>
                                <td style="vertical-align: top; width: 10%; height: 14%">

                                    <asp:Label ID="lblRecp"  Font-Names="Verdana" Font-Size="10pt" runat="server" Text="Receipt&nbsp;No." Font-Bold="False" meta:resourcekey="lblRecpResource1"></asp:Label>
                                </td>
                                <td style="vertical-align: top; width: 2%; height: 14%">
                                    <strong style="font-size:10pt">:</strong>
                                </td>
                                <td style="vertical-align: top; width: 38%; height: 14%">
                                    <asp:Label ID="LblReceiptNo" runat="server" Font-Names="Verdana" Font-Size="10pt"
                                        Font-Bold="False" meta:resourcekey="LblReceiptNoResource1"></asp:Label>
                                </td>
                            </tr>
                            <tr style="font-size: 12pt">
                                <td style="vertical-align: top; width: 10%; height: 14%">
                                    <asp:Label ID="lblAge" Font-Names="Verdana" Font-Size="10pt" runat="server" Text="Age/Sex" meta:resourcekey="lblAgeResource1"></asp:Label>

                                </td>
                                <td style="vertical-align: top; width: 2%; height: 14%">
                                    <strong style="font-size:10pt">:</strong>
                                </td>
                                <td style="vertical-align: top; width: 38%; height: 14%">
                                    <asp:Label ID="LblAgeSex" runat="server" Font-Names="Verdana" Font-Size="10pt"
                                        Width="193px" meta:resourcekey="LblAgeSexResource1"></asp:Label>
                                </td>
                                <td style="vertical-align: top; width: 10%; height: 14%">
                                 <asp:Label ID="lblPanel" runat="server" Text="Panel" Font-Names="Verdana" Font-Size="10pt"></asp:Label>


                                </td>
                                <td style="vertical-align: top; width: 2%; height: 14%">
                                    <strong style="font-size:10pt">:</strong>
                                </td>
                                <td style="vertical-align: top; width: 38%; height: 14%">
                                      <asp:Label ID="lblPanelCompany" Font-Names="Verdana" Font-Size="10pt" runat="server"
                                         ></asp:Label>

                                </td>
                            </tr>
                            <tr style="font-size: 12pt">
                                <td style="vertical-align: top; width: 10%; height: 14%" >

                                    <asp:Label ID="lblAddress1" runat="server" Font-Names="Verdana" Font-Size="10pt" Text="Address" meta:resourcekey="lblAddress1Resource1"></asp:Label>
                                </td>
                                <td style="vertical-align: top; width: 2%; height: 14%" >
                                    <strong style="font-size:10pt">:</strong>
                                </td>
                                <td style="vertical-align: top; width: 38%; height: 14%" >
                                    <asp:Label ID="lblAddress" runat="server" Font-Names="Verdana" Font-Size="10pt" meta:resourcekey="lblAddressResource1"></asp:Label>
                                </td>

                                
                                <td style="vertical-align: top; width: 10%; height: 14%" >
                                    <asp:Label ID="lblContactno" runat="server" Font-Names="Verdana" Font-Size="10pt" Text="Contact&nbsp;No." meta:resourcekey="lblContactnoResource1"></asp:Label>
                                </td>
                                <td style="vertical-align: top; width: 2%; height: 14%" ><strong style="font-size:10pt">:</strong></td>
                                <td style="vertical-align: top; width: 38%; height: 14%" >
                                    <asp:Label ID="lblMobile" runat="server" Font-Names="Verdana" Font-Size="10pt" meta:resourcekey="lblMobileResource1"></asp:Label>
                                </td>
                                 
                            </tr>
                                  <tr id="trSeenby" runat="server" visible="false">
                                    <td style="vertical-align: top; width: 15%; height: 14%" class="bottom">

                                        <asp:Label ID="lblSeenby" runat="server" Font-Names="Verdana" Font-Size="10pt" Text="Seen By Doctor"></asp:Label>
                                    </td>
                                    <td style="vertical-align: top; width: 2%; height: 14%" class="bottom">
                                        <strong style="font-size: 10pt">:</strong>
                                    </td>
                                    <td style="vertical-align: top; width: 42%; height: 14%" class="bottom">
                                        <asp:Label ID="lblSeenbyName" runat="server" Font-Names="Verdana" Font-Size="10pt"></asp:Label>
                                    </td>
                                    <td style="vertical-align: top; width: 15%; height: 14%" class="bottom"></td>
                                    <td style="vertical-align: top; width: 2%; height: 14%" class="bottom"></td>
                                    <td style="vertical-align: top; width: 33%; height: 14%" class="bottom"></td>


                                </tr>
                            <tr style="display:none">
                                <td style="vertical-align: top; width: 10%; height: 14%" class="bottom">
                                    <asp:Label ID="lblDepartment" Font-Names="Verdana" Font-Size="10pt" runat="server" Text="Department" Font-Bold="true"></asp:Label></td>
                                <td style="vertical-align: top; width: 2%; height: 14%" class="bottom">
                                    <strong style="font-size:10pt">:</strong>  </td>
                                <td style="vertical-align: top; width: 38%; height: 14%" class="bottom">
                                    <asp:Label ID="lblDocDepartment" runat="server" Font-Names="Verdana" Font-Size="10pt" Font-Bold="true"></asp:Label>


                                </td>
                                
                                <td style="width: 10%; vertical-align: top" class="bottom">

                                    <asp:Label ID="lblRelation" runat="server" Text="" style="font-size: 10pt"></asp:Label>
                                </td>
                                <td style="vertical-align: top; width: 2%; height: 14%" class="bottom">
                                   <strong style="font-size:10pt"> :</strong></td>
                                <td style="vertical-align: top; width: 38%; height: 14%" class="bottom">
                                  <%-- <b>Valid for 14 Days </b> --%>
                                     <asp:Label ID="lblRelationName" runat="server" Text="" style="font-size: 10pt"></asp:Label>
                                </td>
                            </tr>
                            <tr >
                                <td class="leftbottomright" colspan="8" style="text-align: center; width: 100%">
                                    <table style="width:100%">
                                        <tr><td style="text-align:center" colspan="7">
                                                <asp:Label ID="LblDoctorName" runat="server" Font-Names="Verdana" Font-Size="12pt"
                                        Font-Bold="true" meta:resourcekey="LblDoctorNameResource1"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="text-align:center" colspan="6">
                                                <asp:Label ID="lblDocDegree" runat="server" Font-Names="Verdana" Font-Size="8pt"
                                        Font-Bold="true" ></asp:Label>
                                            </td>
                                            </tr>
                                            <tr style="display:none">
                                            <td style="text-align:center" colspan="6">
                                              <asp:Label ID="lbldept" runat="server" Font-Names="Verdana" Font-Size="10pt" Font-Bold="true"></asp:Label></td>
                                        </tr>
                                    </table>
                                    

                                </td>

                            </tr>
                          

                        </table>

                    </td>
                </tr>
                    </tbody>
               
              <tfoot style="display:table-footer-group;">
                    <tr >
                        <td>
                            <div  style="min-height:630px">
                                                          </div>
                           
                                  <table  style="width:100%">
                                    <tr style="display:none" >
                                        <td colspan="2" style="border-top: thin solid black; ">
                                           <b><u><I>&nbsp;&nbsp;&nbsp;Note :</I></u></b> Paediatric  Cardiac  Camp  by  Dr. Pankaj Bajpayee  from  Medanta The  Medicity , Gurgaon , on 5th of every &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;month(8 am to 3 pm). &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp; For Appointment Call : 8573037503 
                                        </td>
                                       
                                    </tr>
                                   
                                    <%--<tr>
                                        <td  style="vertical-align: top; width: 10%; height: 14%">
                                    <asp:Label ID="lblPrepared" runat="server" Text="Preared&nbsp;By&nbsp;:" ></asp:Label>

                                        </td>
                                         <td style="text-align:left">
<asp:Label ID="lblPreparedBy" runat="server" 
                                        ></asp:Label>
                                        </td>
                                    </tr>--%>
                                </table> 
                           
                        </td>
                    </tr>
                </tfoot>
            </table>
        </div>
    </form>
</body>
</html>
