<%@ Page Language="C#" AutoEventWireup="true" CodeFile="VitalSignChart.aspx.cs" Inherits="Design_IPD_VitalSignChart" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="../../Styles/jquery-ui.css" />

    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.js"></script>

    <script type="text/javascript" src="../../Scripts/jquery.extensions.js"></script>
    <script type="text/javascript">
        function print1() {

            var IPDNo="<%=ViewState["IPDNO"].ToString()%>";
            var EMGNo = "<%=ViewState["EMGNo"].ToString()%>";
            var printContents = '<div style="text-align: center" class="POuter_Box_Inventory"><b>Vital Sign Chart</b></br> ';
            if (IPDNo != '')
                printContents += '<b>IPD No. : ' + IPDNo + '</b> ';
            else
                printContents += '<b>Emenegency No. : ' + EMGNo + '</b>';
            printContents +='</div>';
            printContents += document.getElementById('printData').innerHTML;
            var originalContents = document.body.innerHTML;

            document.body.innerHTML = printContents;

            window.print();

            document.body.innerHTML = originalContents;
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">
            <div style="text-align: center" class="POuter_Box_Inventory">
                <b>Vital Sign Chart</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" ForeColor="Red" Font-Size="Large"></asp:Label>
                    <input type="button" id="btnPrint" onclick="print1()" value="Print" style="margin-left:95%;" />
               
            </div>
            <div id="printData">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">Temperature Chart</div>
                <asp:Chart ID="chartTemp" runat="server"  Width="960px" Height="280px" BackColor="WhiteSmoke">
                    
                    <Legends>

                        <asp:Legend Name="DefaultLegend" Docking="Top" />

                    </Legends>
                    <Series>
                        <asp:Series ChartType="FastLine" Name="Temp" >
                        </asp:Series>
                    </Series>
                    <ChartAreas>
                        <asp:ChartArea Name="ChartArea1">
                            <AxisY LineColor="64, 64, 64, 64" LabelAutoFitMaxFontSize="8">
                                    <LabelStyle Font="Trebuchet MS, 8.25pt, style=Bold" />
                                    
                                  <MajorGrid LineColor="#e6e6e6" />
                                </AxisY>
                                <AxisX LineColor="64, 64, 64, 64" LabelAutoFitMaxFontSize="8">
                                    <LabelStyle Font="Trebuchet MS, 8.25pt, style=Bold" />
                                   <MajorGrid LineColor="#e6e6e6" />
                                </AxisX>

                        </asp:ChartArea>
                    </ChartAreas>
                </asp:Chart>

            </div>
             <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">Blood Pressure Chart</div>
                <asp:Chart ID="chartBP" runat="server"  Width="960px" Height="280px" BackColor="WhiteSmoke">
                    
                    <Legends>
                        <asp:Legend Name="DefaultLegend" Docking="Top" />
                    </Legends>
                    <Series>
                        <asp:Series ChartType="Line" Name="Systolic" Color="Red" >
                         </asp:Series>
                        <asp:Series ChartType="Line" Name="Diastolic" Color="Blue" >
                        </asp:Series>
                    </Series>
                    <ChartAreas>
                        <asp:ChartArea Name="ChartArea2">
                            <AxisY LineColor="64, 64, 64, 64" LabelAutoFitMaxFontSize="8">
                                    <LabelStyle Font="Trebuchet MS, 8.25pt, style=Bold" />
                                    
                                  <MajorGrid LineColor="#e6e6e6" />
                                </AxisY>
                                <AxisX LineColor="64, 64, 64, 64" LabelAutoFitMaxFontSize="8">
                                    <LabelStyle Font="Trebuchet MS, 8.25pt, style=Bold" />
                                   <MajorGrid LineColor="#e6e6e6" />
                                </AxisX>

                        </asp:ChartArea>
                    </ChartAreas>
                </asp:Chart>

            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">Pulse Graph</div>
                <asp:Chart ID="chartPL" runat="server"  Width="960px" Height="270px" BackColor="WhiteSmoke" BackGradientStyle="None">
                    
                    <Legends>

                        <asp:Legend Name="DefaultLegend" Docking="Top" />

                    </Legends>
                    <Series>
                        <asp:Series ChartType="Line" Name="Pulse"   >
                        </asp:Series>
                    </Series>
                    <ChartAreas>
                        <asp:ChartArea Name="ChartArea3">
                             <AxisY LineColor="64, 64, 64, 64" LabelAutoFitMaxFontSize="8">
                                    <LabelStyle Font="Trebuchet MS, 8.25pt, style=Bold" />
                                    
                                  <MajorGrid LineColor="#e6e6e6" />
                                </AxisY>
                                <AxisX LineColor="64, 64, 64, 64" LabelAutoFitMaxFontSize="8">
                                    <LabelStyle Font="Trebuchet MS, 8.25pt, style=Bold" />
                                   <MajorGrid LineColor="#e6e6e6" />
                                </AxisX>
                        </asp:ChartArea>
                    </ChartAreas>
                </asp:Chart>

            </div>
              <div runat="server" visible="false" class="POuter_Box_Inventory" id="divDiabetic">
                <div class="Purchaseheader">Diabetic Graph</div>
                <asp:Chart ID="chartDiab" runat="server"  Width="960px" Height="280px" BackColor="WhiteSmoke">
                    
                    <Legends>

                        <asp:Legend Name="DefaultLegend" Docking="Top" />

                    </Legends>
                    <Series>
                        <asp:Series ChartType="Line" Name="Diabiatic" Color="Red"   >
                        </asp:Series>
                    </Series>
                    <ChartAreas>
                        <asp:ChartArea Name="ChartArea4">
                            <AxisY LineColor="64, 64, 64, 64" LabelAutoFitMaxFontSize="8">
                                    <LabelStyle Font="Trebuchet MS, 8.25pt, style=Bold" />
                                    
                                  <MajorGrid LineColor="#e6e6e6" />
                                </AxisY>
                                <AxisX LineColor="64, 64, 64, 64" LabelAutoFitMaxFontSize="8">
                                    <LabelStyle Font="Trebuchet MS, 8.25pt, style=Bold" />
                                   <MajorGrid LineColor="#e6e6e6" />
                                </AxisX>

                        </asp:ChartArea>
                    </ChartAreas>
                </asp:Chart>

            </div>
                <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">SPO2 Chart</div>
                <asp:Chart ID="chartSPO2" runat="server"  Width="960px" Height="280px" BackColor="WhiteSmoke">
                    
                    <Legends>

                        <asp:Legend Name="DefaultLegend" Docking="Top" />

                    </Legends>
                    <Series>
                        <asp:Series ChartType="FastLine" Name="SPO2" >
                        </asp:Series>
                    </Series>
                    <ChartAreas>
                        <asp:ChartArea Name="ChartArea1">
                            <AxisY LineColor="64, 64, 64, 64" LabelAutoFitMaxFontSize="8">
                                    <LabelStyle Font="Trebuchet MS, 8.25pt, style=Bold" />
                                    
                                  <MajorGrid LineColor="#e6e6e6" />
                                </AxisY>
                                <AxisX LineColor="64, 64, 64, 64" LabelAutoFitMaxFontSize="8">
                                    <LabelStyle Font="Trebuchet MS, 8.25pt, style=Bold" />
                                   <MajorGrid LineColor="#e6e6e6" />
                                </AxisX>

                        </asp:ChartArea>
                    </ChartAreas>
                </asp:Chart>

            </div>
            
                </div>
        </div>
    </form>
</body>
</html>
