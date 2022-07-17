export interface ContributionProps {
  amount: number;
  source?: LegalEntityProps;
  destination?: LegalEntityProps;
}

export interface LegalEntityProps {
  id: string;
  name: string;
  type: string;
  state: string;
  country: string;
  entityType?: string;
  fecForiegnKey: string;
  totalOutboundContributions: number;
  totalInboundContributions: number;
  outboundContributions: Array<ContributionProps>;
  inboundContributions: Array<ContributionProps>;
}
